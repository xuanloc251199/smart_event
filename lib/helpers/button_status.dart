class ButtonStatus {
  static String getButtonText(String status) {
    switch (status) {
      case 'register':
        return 'Register';
      case 'registered':
        return 'Registered';
      case 'check_in':
        return 'Check In';
      case 'checked_in':
        return 'Checked In';
      case 'absent':
        return 'Absent';
      default:
        return 'Disabled';
    }
  }
}
