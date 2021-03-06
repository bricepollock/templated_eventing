enum class PageViewedEventPagename(val name: String) {
      APPLICATION_SIGN_IN("application.sign_in"),
      APPLICATION_SETTINGS("application.settings"),
      SETTINGS_NOTIFICATIONS("settings.notifications"),
    
}

data class PageViewedEvent(val pageName: PageViewedEventPagename) {
    val name: String = "page_viewed"
    val parameters: [String: Any]? {
        return [
            "page_name": self.pageName.name
        ]
    }
}
