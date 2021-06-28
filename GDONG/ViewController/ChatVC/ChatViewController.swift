//
//  ChatViewController.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/06/24.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {

    var messages: [Message] = []
    var member: Member!
    
    private var selfSender: Sender? {
        guard let email = UserDefaults.standard.value(forKey: UserDefaultKey.userEmail) as? String else {
            return nil
        }
       
        return Sender(photoURL: "",
                      senderId: email,
                      displayName: "Me")
    }
    
    public static let dateFormatter: DateFormatter = {
        let formattre = DateFormatter()
        formattre.dateStyle = .medium
        formattre.timeStyle = .long
        formattre.locale = .current
        return formattre
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        member = Member(name: "bluemoon", color: .blue)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        //messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self

    }
    


}

extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }

        fatalError("Self Sender is nil, email should be cached")
    }
    
    func numberOfSections(
    in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }


  func messageForItem(
    at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView) -> MessageType {

    return messages[indexPath.section]
  }

  func messageTopLabelHeight(
    for message: MessageType,
    at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView) -> CGFloat {

    return 12
  }

  func messageTopLabelAttributedText(
    for message: MessageType,
    at indexPath: IndexPath) -> NSAttributedString? {

    return NSAttributedString(
      string: message.sender.displayName,
      attributes: [.font: UIFont.systemFont(ofSize: 12)])
  }
}

extension ChatViewController: MessagesLayoutDelegate {
  func heightForLocation(message: MessageType,
    at indexPath: IndexPath,
    with maxWidth: CGFloat,
    in messagesCollectionView: MessagesCollectionView) -> CGFloat {

    return 0
  }
}

extension ChatViewController: MessagesDisplayDelegate {
  func configureAvatarView(
    _ avatarView: AvatarView,
    for message: MessageType,
    at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView) {

//    let message = messages[indexPath.section]
//    let color = message.member.color
//    avatarView.backgroundColor = color
    //TO DO - set image need
  }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
            let selfSender = self.selfSender,
            let messageId = createMessageId() else {
                return
        }

        print("Sending: \(text)")

        let mmessage = Message(sender: selfSender,
                               messageId: messageId,
                               sentDate: Date(),
                               kind: .text(text))
        messages.append(mmessage)
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem()

        // Send Message
//        if isNewConversation {
//            // create convo in database
//            DatabaseManager.shared.createNewConversation(with: otherUserEmail, name: self.title ?? "User", firstMessage: mmessage, completion: { [weak self]success in
//                if success {
//                    print("message sent")
//                    self?.isNewConversation = false
//                    let newConversationId = "conversation_\(mmessage.messageId)"
//                    self?.conversationId = newConversationId
//                    //self?.listenForMessages(id: newConversationId, shouldScrollToBottom: true)
//                    self?.messageInputBar.inputTextView.text = nil
//                }
//                else {
//                    print("faield ot send")
//                }
//            })
//        }
//        else {
//            guard let conversationId = conversationId, let name = self.title else {
//                return
//            }
//
//            // append to existing conversation data
//            DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: otherUserEmail, name: name, newMessage: mmessage, completion: { [weak self] success in
//                if success {
//                    self?.messageInputBar.inputTextView.text = nil
//                    print("message sent")
//                }
//                else {
//                    print("failed to send")
//                }
//            })
//        }
    }

    private func createMessageId() -> String? {
        // date, otherUesrEmail, senderEmail, randomInt
        guard let currentUserEmail = UserDefaults.standard.value(forKey: UserDefaultKey.userEmail) as? String else {
            return nil
        }

        //let safeCurrentEmail = DatabaseManager.safeEmail(emailAddress: currentUserEmail)

        let dateString = Self.dateFormatter.string(from: Date())
        let newIdentifier = "\(currentUserEmail)_\(dateString)"

        print("created message id: \(newIdentifier)")

        return newIdentifier
    }
}
