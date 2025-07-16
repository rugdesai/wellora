import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyPlannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planner App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: PlannerHomePage(),
    );
  }
}

class PlannerHomePage extends StatefulWidget {
  @override
  _PlannerHomePageState createState() => _PlannerHomePageState();
}

class _PlannerHomePageState extends State<PlannerHomePage> {
  final List<String> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  final FocusNode _taskFocusNode = FocusNode();

  final List<String> _priorities = [];
  final TextEditingController _priorityController = TextEditingController();
  final FocusNode _priorityFocusNode = FocusNode();

  final TextEditingController _notesController = TextEditingController();

  List<bool> _scheduleChecked = List.generate(18, (_) => false);
  late List<TextEditingController> _scheduleControllers;

  @override
  void initState() {
    super.initState();
    _scheduleControllers = List.generate(18, (_) => TextEditingController());
  }

  @override
  void dispose() {
    _taskController.dispose();
    _taskFocusNode.dispose();
    _priorityController.dispose();
    _priorityFocusNode.dispose();
    _notesController.dispose();
    super.dispose();
    for (var controller in _scheduleControllers) {
      controller.dispose();
    }
  }

  void _addTask() {
    if (_taskController.text.trim().isNotEmpty) {
      setState(() {
        _tasks.add(_taskController.text.trim());
        _taskController.clear();
      });
      _taskFocusNode.requestFocus();
    }
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _addPriority() {
    if (_priorityController.text.trim().isNotEmpty) {
      setState(() {
        _priorities.add(_priorityController.text.trim());
        _priorityController.clear();
      });
      _priorityFocusNode.requestFocus();
    }
  }

  void _removePriority(int index) {
    setState(() {
      _priorities.removeAt(index);
    });
  }

  Widget buildSchedule() {
    final times = List.generate(18, (index) {
      final hour = index + 6;
      final suffix = hour >= 12 ? "PM" : "AM";
      final displayHour = hour > 12 ? hour - 12 : hour;
      return "$displayHour:00 $suffix";
    });

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.builder(
        itemCount: times.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: _scheduleChecked[index],
                  onChanged: (val) {
                    setState(() {
                      _scheduleChecked[index] = val ?? false;
                    });
                  },
                ),
                SizedBox(width: 4),
                Text(
                  times[index],
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _scheduleControllers[index],
                    decoration: InputDecoration(
                      hintText: index == 0 ? 'Enter task...' : null,
                      border: InputBorder.none,
                      filled: false,
                    ),
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildTaskList() {
    if (_tasks.isEmpty) {
      return Center(
          child: Text('No tasks', style: TextStyle(color: Colors.grey)));
    }
    return ListView.builder(
      itemCount: _tasks.length,
      itemBuilder: (context, index) => Card(
        margin: EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          title: Text(_tasks[index]),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _removeTask(index),
          ),
        ),
      ),
    );
  }

  Widget buildPriorityList() {
    if (_priorities.isEmpty) {
      return Center(
          child: Text('No priorities', style: TextStyle(color: Colors.grey)));
    }
    return ListView.builder(
      itemCount: _priorities.length,
      itemBuilder: (context, index) => Card(
        margin: EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          title: Text(_priorities[index]),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _removePriority(index),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/features/to_do_list/assets/bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(color: Colors.white.withOpacity(0.3)),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              'PLANNER',
              style: GoogleFonts.dynaPuff(
                textStyle: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: 2,
                ),
              ),
            ),
            backgroundColor: Colors.blue.withOpacity(0.1),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                // Left schedule panel
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Schedule',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Expanded(
                        child: buildSchedule(),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 12),

                // Right side with tasks, priorities, notes
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      // To-Do List section
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'To-Do List',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _taskController,
                                    focusNode: _taskFocusNode,
                                    autofocus: true,
                                    onSubmitted: (_) => _addTask(),
                                    decoration: InputDecoration(
                                      hintText: 'Add a new task',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: _addTask,
                                  child: Icon(Icons.add),
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(14),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              height: 150,
                              child: buildTaskList(),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 12),

                      // Priorities section
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Priorities',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _priorityController,
                                    focusNode: _priorityFocusNode,
                                    onSubmitted: (_) => _addPriority(),
                                    decoration: InputDecoration(
                                      hintText: 'Add a priority',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: _addPriority,
                                  child: Icon(Icons.add),
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(14),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              height: 150,
                              child: buildPriorityList(),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 12),

                      // Notes section
                      Flexible(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Notes',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              SizedBox(height: 8),
                              Expanded(
                                child: TextField(
                                  controller: _notesController,
                                  maxLines: null,
                                  expands: true,
                                  decoration: InputDecoration(
                                    hintText: 'Write your notes here...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
