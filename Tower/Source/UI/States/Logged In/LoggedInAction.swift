public enum LoggedInAction {
    case conversations(ConversationsAction)
    case tracking(TrackingAction)
    case notifications(NotificationsAction)
}
