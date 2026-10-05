import Foundation

/**
 * Avatars: the catalog the operator ships, the user's AI-customized ones, the
 * prompt catalog, and the customization call itself.
 *
 * Image fields arrive as paths relative to the environment's image CDN — the
 * transforms below expand them to absolute URLs so a UI can use them directly.
 */
extension SmarticoApi {
    public func getAvatarsList() async throws -> [TAvatarDefinition] {
        try await call(
            cid: ClassId.GET_AVATARS_LIST_REQUEST,
            expectCid: ClassId.GET_AVATARS_LIST_RESPONSE,
            GetAvatarsListResponse.self
        ).avatars.orEmpty().map { $0.toTAvatarDefinition(avatarDomain()) }
    }

    /** The user's AI-generated avatars. */
    public func getAvatarsCustomized() async throws -> [TAvatarCustomized] {
        try await call(
            cid: ClassId.GET_AVATARS_CUSTOMIZED_REQUEST,
            expectCid: ClassId.GET_AVATARS_CUSTOMIZED_RESPONSE,
            GetAvatarsCustomizedResponse.self
        ).avatars.orEmpty().map { $0.toTAvatarCustomized(avatarDomain()) }
    }

    /** The styles ("prompts") the operator offers for AI customization, with their price. */
    public func getAvatarPrompts() async throws -> [TAvatarPrompt] {
        try await call(
            cid: ClassId.GET_AVATAR_PROMPTS_REQUEST,
            expectCid: ClassId.GET_AVATAR_PROMPTS_RESPONSE,
            GetAvatarPromptsResponse.self
        ).prompts.orEmpty().map { $0.toTAvatarPrompt(avatarDomain()) }
    }

    /** Set the user's avatar. Pass both ids from the catalog entry. */
    public func setAvatar(avatar_url: String, avatar_real_id: Int64) async throws -> TSetAvatarResult {
        try requireArg(!avatar_url.isEmpty, "avatar_url is required")
        try requireArg(avatar_real_id != 0, "avatar_real_id is required")
        // Same rule as the nickname below: the request stores the avatar, while
        // "changed the avatar" missions listen for this separate client event —
        // it travels alongside the request, not inside it.
        conn.sendClientEvent("gf_avatar_changed")
        let r = try await call(
            cid: ClassId.CLIENT_SET_AVATAR_REQUEST,
            expectCid: ClassId.CLIENT_SET_AVATAR_RESPONSE,
            SetAvatarResponse.self,
            payload: [
                // the protocol calls it avatar_id, the public API avatar_url — it
                // carries the catalog entry's url either way
                "avatar_id": JSON(avatar_url),
                "avatar_real_id": JSON(avatar_real_id),
            ]
        )
        return TSetAvatarResult(err_code: r.errCode ?? 0, err_message: r.errMsg)
    }

    /**
     * AI avatar customization — takes a base avatar plus a prompt (style) and
     * returns the generated one. This is an HTTP POST to the avatar service, not a
     * socket request, and it costs the user points/gems per the prompt's price.
     *
     * `userId` is the NUMERIC Smartico user id, available from the public
     * properties after identify (`user_id`), not the external id.
     */
    public func avatarsCustomize(
        userId: Int64,
        promptId: Int64,
        avatarUrl: String,
        avatarRealId: Int64
    ) async throws -> AvatarCustomizeResponse? {
        let body = avatarsCustomizeBody(userId: userId, promptId: promptId, avatarUrl: avatarUrl, avatarRealId: avatarRealId)
        guard let raw = await conn.httpPostJson("\(avatarDomain())/avatar-customize", body: body) else { return nil }
        return try decodeWire(AvatarCustomizeResponse.self, raw)
    }

    /** The avatar-customize POST body (split out of `avatarsCustomize` so it is testable without spending points). */
    func avatarsCustomizeBody(userId: Int64, promptId: Int64, avatarUrl: String, avatarRealId: Int64) -> JSONObject {
        var body: JSONObject = [
            // label_api_key must be the CLEAN key: the service resolves the label
            // from it, and the "-<env>" suffix is a client-side routing hint only.
            "label_api_key": JSON(Env.cleanLabelKey(conn.label)),
            "user_id": JSON(userId),
            "user_ext_id": JSON(conn.extUserId),
        ]
        // the service prices the prompt per brand — without it the request is
        // rejected on multi-brand labels
        if let brandKey = conn.brandKey { body["brand_key"] = JSON(brandKey) }
        body["prompt_id"] = JSON(promptId)
        body["avatar_url"] = JSON(avatarUrl)
        body["avatar_real_id"] = JSON(avatarRealId)
        return body
    }

    private func avatarDomain() -> String { Env.avatarUrl(conn.label) }
}

/** Relative paths are expanded against the environment's image CDN. */
private func absoluteUrl(_ url: String?, _ domain: String) -> String? {
    if let url = url, !url.hasPrefix("http") { return "\(domain)\(url)" }
    return url
}

private extension Optional where Wrapped == JSON {
    /**
     * `public_meta` is an inline object in the protocol (no named type to generate
     * from), so its fields are read straight off the JSON.
     */
    func str(_ key: String) -> String? {
        self?.object?[key]?.string
    }
}

extension AvatarDefinition {
    func toTAvatarDefinition(_ domain: String) -> TAvatarDefinition {
        TAvatarDefinition(
            avatar_real_id: avatar_real_id,
            is_default: is_default,
            hide_until_achieved: hide_until_achieved,
            priority: priority,
            description: public_meta.str("description"),
            url: public_meta.str("url"),
            avatar_url: absoluteUrl(public_meta.str("url"), domain),
            avatar_source_type_id: avatar_source_type_id,
            active_from_date: active_from_date,
            active_till_date: active_till_date,
            is_given: is_given,
            is_in_use: is_in_use
        )
    }
}

extension AvatarCustomized {
    func toTAvatarCustomized(_ domain: String) -> TAvatarCustomized {
        TAvatarCustomized(
            avatar_real_id: avatar_real_id,
            url: absoluteUrl(url, domain),
            dt_created: dt_created
        )
    }
}

extension AvatarPrompt {
    func toTAvatarPrompt(_ domain: String) -> TAvatarPrompt {
        TAvatarPrompt(
            prompt_id: prompt_id,
            name: public_meta.str("name"),
            icon_url: absoluteUrl(public_meta.str("icon_url"), domain),
            cost_currency_type_id: cost_currency_type_id,
            cost_value: cost_value
        )
    }
}
