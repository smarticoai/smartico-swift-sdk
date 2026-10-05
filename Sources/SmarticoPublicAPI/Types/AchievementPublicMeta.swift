// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct AchievementPublicMeta: Codable, Hashable, Sendable {
    public var sub_header: String?
    public var description: String?
    public var unlock_mission_description: String?
    public var custom_data: String?
    public var cta_text: String?
    public var cta_action: String?
    public var label_tag: String?
    public var custom_label_tag: String?
    public var reward: String?
    public var image_url: String?
    public var name: String?
    public var position: Int64?
    public var hide_tasks: Bool?
    public var hide_locked_mission: Bool?
    public var custom_section_id: Int64?
    public var only_in_custom_section: Bool?
    public var hint_text: String?
    public var hide_badge_from_ui: Bool?
    public var show_badge_first_task_completed: Bool?
    public var custom_section_type_id: Int64?
    public var claim_button_title: String?
    public var claim_button_action: String?

    public init(
        sub_header: String? = nil,
        description: String? = nil,
        unlock_mission_description: String? = nil,
        custom_data: String? = nil,
        cta_text: String? = nil,
        cta_action: String? = nil,
        label_tag: String? = nil,
        custom_label_tag: String? = nil,
        reward: String? = nil,
        image_url: String? = nil,
        name: String? = nil,
        position: Int64? = nil,
        hide_tasks: Bool? = nil,
        hide_locked_mission: Bool? = nil,
        custom_section_id: Int64? = nil,
        only_in_custom_section: Bool? = nil,
        hint_text: String? = nil,
        hide_badge_from_ui: Bool? = nil,
        show_badge_first_task_completed: Bool? = nil,
        custom_section_type_id: Int64? = nil,
        claim_button_title: String? = nil,
        claim_button_action: String? = nil
    ) {
        self.sub_header = sub_header
        self.description = description
        self.unlock_mission_description = unlock_mission_description
        self.custom_data = custom_data
        self.cta_text = cta_text
        self.cta_action = cta_action
        self.label_tag = label_tag
        self.custom_label_tag = custom_label_tag
        self.reward = reward
        self.image_url = image_url
        self.name = name
        self.position = position
        self.hide_tasks = hide_tasks
        self.hide_locked_mission = hide_locked_mission
        self.custom_section_id = custom_section_id
        self.only_in_custom_section = only_in_custom_section
        self.hint_text = hint_text
        self.hide_badge_from_ui = hide_badge_from_ui
        self.show_badge_first_task_completed = show_badge_first_task_completed
        self.custom_section_type_id = custom_section_type_id
        self.claim_button_title = claim_button_title
        self.claim_button_action = claim_button_action
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.sub_header = try c.lenientString("sub_header")
        self.description = try c.lenientString("description")
        self.unlock_mission_description = try c.lenientString("unlock_mission_description")
        self.custom_data = try c.lenientString("custom_data")
        self.cta_text = try c.lenientString("cta_text")
        self.cta_action = try c.lenientString("cta_action")
        self.label_tag = try c.lenientString("label_tag")
        self.custom_label_tag = try c.lenientString("custom_label_tag")
        self.reward = try c.lenientString("reward")
        self.image_url = try c.lenientString("image_url")
        self.name = try c.lenientString("name")
        self.position = try c.lenientInt64("position")
        self.hide_tasks = try c.lenientBool("hide_tasks")
        self.hide_locked_mission = try c.lenientBool("hide_locked_mission")
        self.custom_section_id = try c.lenientInt64("custom_section_id")
        self.only_in_custom_section = try c.lenientBool("only_in_custom_section")
        self.hint_text = try c.lenientString("hint_text")
        self.hide_badge_from_ui = try c.lenientBool("hide_badge_from_ui")
        self.show_badge_first_task_completed = try c.lenientBool("show_badge_first_task_completed")
        self.custom_section_type_id = try c.lenientInt64("custom_section_type_id")
        self.claim_button_title = try c.lenientString("claim_button_title")
        self.claim_button_action = try c.lenientString("claim_button_action")
    }
}
