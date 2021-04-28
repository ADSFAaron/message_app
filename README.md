# **聊天**GO

一款真正的聊天軟體

## 已知問題

- member page

  1. 聊天室修改成單獨聊天室
   - 只能存放 chatRoom doc id 進 user fireStore 的chatRoom
     - 聊天室新增 imageURL 功能
  2. 無法刪除聊天室
- friend page

  1. 封鎖 刪除功能還沒製作
  3. 新增好友後 另一邊不會有被加入的通知 也不會直接出現 (這大概可以往express那邊弄)
- chat page

  1. 可傳輸文字及圖片/影片及gif暫且不能
  2. 還沒做出已讀功能
  3. 還沒測試別人的訊息的部分
- setting page
  2. 並不能記憶上次使用的主題是哪個主題/可能需記錄到firestore user裡面

## 預計實作

- [ ] 已讀功能
- [ ] 好友分群功能
- [ ] 聊天室名稱及頭貼自定義
- [x] 個人頭貼及背景圖片自定義