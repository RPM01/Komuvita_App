class NotificationModalData {
  String date = '';
  List<NotificationModal> messagesList = [];

  NotificationModalData({
    required this.date,
  });

  NotificationModalData.fromJson(Map<String, dynamic> json) {
    if (json['date'] != null) {
      date = json['date'];
    }
    if (json['messages'] != null) {
      messagesList = List<dynamic>.from(json['messages'])
          .map((i) => NotificationModal.fromJson(i))
          .toList();
    }
  }
}

class NotificationModal {
  String icon='';
  String title='';
  String description='';
  String time='';

  NotificationModal({
    required this.icon,
    required this.title,
    required this.description,
    required this.time,
  });

  NotificationModal.fromJson(Map<String, dynamic> json) {
    if (json['icon'] != null) {
      icon = json['icon'];
    }
    if (json['title'] != null) {
      title = json['title'];
    }
    if (json['description'] != null) {
      description = json['description'];
    }
    if (json['time'] != null) {
      time = json['time'];
    }
  }
}
