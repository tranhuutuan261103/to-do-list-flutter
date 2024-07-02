class ToDo {
  String id;
  String title;
  bool isCompleted;

  ToDo({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });


  static List<ToDo> todoList() {
    return [
      ToDo(
        id: '1',
        title: 'Morning walk',
        isCompleted: true,
      ),
      ToDo(
        id: '2',
        title: 'Breakfast',
        isCompleted: false,
      ),
      ToDo(
        id: '3',
        title: 'Team meeting',
        isCompleted: false,
      ),
      ToDo(
        id: '4',
        title: 'Work on project',
        isCompleted: false,
      ),
    ];
  }
}