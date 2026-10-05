import Foundation

/**
 * Inbox.
 *
 * The list call returns lightweight ENVELOPES only (guid / date / read /
 * favorite). Title, preview, icon, buttons and html body live in the BODY,
 * which is fetched per message from a CDN over HTTP — see `getInboxMessageBody`.
 * So a screen does one list call, then batches body fetches and caches them.
 *
 * `sent_date` is formatted "dd/MM/yyyy HH:mm:ss", NOT ISO — don't feed it to a
 * date parser expecting ISO.
 */
extension SmarticoApi {
    public func getInboxMessages(
        from: Int = 0,
        to: Int = 20,
        favoriteOnly: Bool = false,
        categoryId: Int64? = nil,
        readStatus: Int64? = nil
    ) async throws -> [TInboxMessage] {
        try await inboxPage(from: from, to: to, favoriteOnly: favoriteOnly, categoryId: categoryId, readStatus: readStatus)
            .log.orEmpty().toTInboxMessages()
    }

    /** Unread badge counter — a 1-item page fetched purely for its `unread_count`. */
    public func getInboxUnreadCount() async throws -> Int64 {
        try await inboxPage(from: 0, to: 1, favoriteOnly: false).unread_count ?? 0
    }

    private func inboxPage(
        from: Int,
        to: Int,
        favoriteOnly: Bool,
        categoryId: Int64? = nil,
        readStatus: Int64? = nil
    ) async throws -> GetInboxMessagesResponse {
        var payload: JSONObject = [
            "limit": JSON(to - from > 20 ? 20 : to - from), // server page cap
            "offset": JSON(from),
            "starred_only": JSON(favoriteOnly),
        ]
        if let categoryId = categoryId { payload["category_id"] = JSON(categoryId) }
        if let readStatus = readStatus { payload["read_status"] = JSON(readStatus) }
        return try await call(
            cid: ClassId.GET_INBOX_MESSAGES_REQUEST,
            expectCid: ClassId.GET_INBOX_MESSAGES_RESPONSE,
            GetInboxMessagesResponse.self,
            payload: payload
        )
    }

    /**
     * Fetch one message's body. This is a plain HTTPS GET against the label's inbox
     * CDN (base comes from the INBOX_PUBLIC_CDN label setting delivered at connect),
     * NOT a socket request. Returns nil when the body is missing or unreachable.
     */
    public func getInboxMessageBody(messageGuid: String) async throws -> TInboxMessageBody? {
        guard let cdn = await conn.getLabelSetting("INBOX_PUBLIC_CDN")?.string else { return nil }
        guard let raw = await conn.httpGetJson("\(cdn)\(messageGuid).json") else { return nil }
        let body = try decodeWire(InboxMessageBody.self, raw)
        return body.toTInboxMessageBody(raw)
    }

    /** Mark one message as read. */
    public func markInboxMessageAsRead(messageGuid: String) async throws -> InboxMarkMessageAction {
        try await conn.request(
            cid: ClassId.MARK_INBOX_READ_REQUEST,
            expectCid: ClassId.MARK_INBOX_READ_RESPONSE,
            payload: ["engagement_uid": JSON(messageGuid)]
        ).toMarkAction()
    }

    /** Star / unstar one message. */
    public func markUnmarkInboxMessageAsFavorite(messageGuid: String, mark: Bool) async throws -> InboxMarkMessageAction {
        try await conn.request(
            cid: ClassId.MARK_INBOX_STARRED_REQUEST,
            expectCid: ClassId.MARK_INBOX_STARRED_RESPONSE,
            payload: [
                "engagement_uid": JSON(messageGuid),
                "is_starred": JSON(mark),
            ]
        ).toMarkAction()
    }

    /** Delete one message. */
    public func deleteInboxMessage(messageGuid: String) async throws -> InboxMarkMessageAction {
        try await conn.request(
            cid: ClassId.MARK_INBOX_DELETED_REQUEST,
            expectCid: ClassId.MARK_INBOX_DELETED_RESPONSE,
            payload: ["engagement_uid": JSON(messageGuid)]
        ).toMarkAction()
    }
}

extension Array where Element == InboxMessage {
    func toTInboxMessages() -> [TInboxMessage] {
        map { item in
            TInboxMessage(
                message_guid: item.engagement_uid,
                sent_date: item.createDate,
                read: item.is_read,
                favorite: item.is_starred,
                category_id: item.category_id,
                expire_on_dt: item.expire_on_dt
            )
        }
    }
}

extension InboxMessageBody {
    /**
     * Wire → public shape. The rich part (html body + CTA buttons) only applies to
     * `dp:inbox` messages; for other actions the message is a plain preview.
     */
    func toTInboxMessageBody(_ raw: JSONObject) -> TInboxMessageBody {
        let isRichInbox = action == "dp:inbox"
        return TInboxMessageBody(
            title: title,
            preview_body: body,
            icon: image,
            action: action,
            html_body: isRichInbox ? html_body : nil,
            buttons: isRichInbox
                ? raw["additional_buttons"]?.array.map { arr -> JSON in
                    .array(arr.compactMap { b -> JSON? in
                        guard let o = b.object else { return nil }
                        return [
                            "action": JSON(o["action"]?.string),
                            "text": JSON(o["inbox_cta_text"]?.string),
                        ]
                    })
                }
                : nil,
            custom_data: jsonOrText(custom_data)
        )
    }
}

extension Dictionary where Key == String, Value == JSON {
    /** Mutations answer with just an error code — surface the public shape. */
    func toMarkAction() -> InboxMarkMessageAction {
        InboxMarkMessageAction(
            err_code: self["errCode"]?.string.flatMap { Double($0) }.map { Lenient.truncate($0) },
            err_message: self["errMsg"]?.string
        )
    }
}
