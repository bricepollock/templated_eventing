struct PageViewedEvent {
    enum Name: String {
      case applicationSignIn = "application.sign_in"
      case applicationSettings = "application.settings"
      case settingsNotifications = "settings.notifications"
    
    }
    
    var name: String {
        return "page_viewed"
    }
    
    var parameters: [String: Any]? {
        return [
            "page_name": self.pageName.rawValue
        ]
    }
    
    private let pageName: Name
    init(pageName: Name) {
        self.pageName = pageName
    }
}
