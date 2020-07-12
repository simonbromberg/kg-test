import Foundation

public class GmailScopes {
    
    /** Read, send, delete, and manage your email. */
    public static let MAIL_GOOGLE_COM = "https://mail.google.com/";
    
    /** Manage drafts and send emails. */
    public static let GMAIL_COMPOSE = "https://www.googleapis.com/auth/gmail.compose";
    
    /** Insert mail into your mailbox. */
    public static let GMAIL_INSERT = "https://www.googleapis.com/auth/gmail.insert";
    
    /** Manage mailbox labels. */
    public static let GMAIL_LABELS = "https://www.googleapis.com/auth/gmail.labels";
    
    /** View and modify but not delete your email. */
    public static let GMAIL_MODIFY = "https://www.googleapis.com/auth/gmail.modify";
    
    /** View your email messages and settings. */
    public static let GMAIL_READONLY = "https://www.googleapis.com/auth/gmail.readonly";
}
