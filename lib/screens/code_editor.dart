import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_code_editor/flutter_code_editor.dart';
import '../utils/code_editor/languages/python.dart';
import '../utils/code_editor/themes/vs_dart.dart';

class CodeEditor extends StatefulWidget {
  const CodeEditor({super.key});

  @override
  State<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  late IO.Socket socket;
  late CodeController controller;

  String output = ''; // To store the output from server
  List<Uint8List> _imageDataList = [];
  String userInput = ''; // To store the user input

  bool isExecuting = false;
  bool isDispose = false;

  final text = '''
import matplotlib.pyplot as plt

n = int(input('Enter the number of elements: '))
data = [int(input(f'Enter element {i + 1}: ')) for i in range(n)]

def tri_recursion(k):
    if k > 0:
        result = k + tri_recursion(k - 1)
        print(result)
    else:
        result = 0
    return result

x = list(range(1, n + 1))
y = data

plt.plot(x, y)
plt.title('Sample Plot')
plt.xlabel('x-axis')
plt.ylabel('y-axis')

# Display the plot
plt.show()

import matplotlib.pyplot as plt

# This function adds two numbers
def add(x, y):
    return x + y

# This function subtracts two numbers
def subtract(x, y):
    return x - y

# This function multiplies two numbers
def multiply(x, y):
    return x * y

# This function divides two numbers
def divide(x, y):
    return x / y


print("Select operation.")
print("1.Add")
print("2.Subtract")
print("3.Multiply")
print("4.Divide")

while True:
    # take input from the user
    choice = input("Enter choice(1/2/3/4): ")

    # check if choice is one of the four options
    if choice in ('1', '2', '3', '4'):
        try:
            num1 = float(input("Enter first number: "))
            num2 = float(input("Enter second number: "))
        except ValueError:
            print("Invalid input. Please enter a number.")
            continue

        if choice == '1':
            print(num1, "+", num2, "=", add(num1, num2))

        elif choice == '2':
            print(num1, "-", num2, "=", subtract(num1, num2))

        elif choice == '3':
            print(num1, "*", num2, "=", multiply(num1, num2))

        elif choice == '4':
            print(num1, "/", num2, "=", divide(num1, num2))
        
        # check if user wants another calculation
        # break the while loop if answer is no
        next_calculation = input("Let's do next calculation? (yes/no): ")
        if next_calculation == "no":
          break
    else:
        print("Invalid Input")
''';

  @override
  void initState() {
    super.initState();

    // Thiết lập kết nối socket
    socket = IO.io('http://66.45.239.69:5997/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onDisconnect((_) => {
          // check if out of context
          if (mounted && !isDispose)
            {
              setState(() {
                output += 'Disconnected from server.\n';
                isExecuting = false;
              })
            }
        });

    // Lắng nghe sự kiện từ server
    socket.on('output_result', (data) {
      // {data: Hello, World!} => Hello, World!
      setState(() {
        output += '${data['data']}';
        isExecuting = false;
      });
    });

    socket.on('output_image', (data) {
      // Decode the base64 string into Uint8List
      String base64Image = data['stream'];
      Uint8List decodedBytes = base64Decode(base64Image);

      // Update the state to add the image to the list
      setState(() {
        _imageDataList.add(decodedBytes); // Add the new image to the list
        isExecuting = false;
      });
    });

    socket.on('output_error', (data) {
      setState(() {
        output += '${data['data']}';
        isExecuting = false;
      });
    });

    socket.on('request_input', (data) {
      setState(() {
        output += '${data['data']}\n';
        isExecuting = true;
      });
      // Show input field to user
      _showInputDialog(data['data']);
    });

    // Khởi tạo CodeController với ngôn ngữ Python
    controller = CodeController(
      text: text,
      language: python,
    );
  }

  void _executeCode() {
    final code = controller.text;
    socket.emit('execute_code', {'code': code});
    setState(() {
      isExecuting = true;
      output = ''; // Clear output before executing
      _imageDataList.clear(); // Clear images before executing
    });
  }

  void _sendUserInput() {
    socket.emit('user_input', {'input': userInput});
    setState(() {
      userInput = ''; // Clear input after sending
    });
  }

  void _showInputDialog(String prompt) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Input Required'),
          content: TextField(
            onChanged: (value) {
              userInput = value;
            },
            decoration: InputDecoration(
              hintText: prompt,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                _sendUserInput();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    isDispose = true;
    socket.dispose(); // Hủy kết nối socket khi không cần thiết
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Code Editor'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                CodeTheme(
                  data: CodeThemeData(styles: vsDart),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: CodeField(
                      controller: controller,
                      minLines: 12,
                      gutterStyle: GutterStyle.none,
                      wrap: true,
                      textStyle: GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: isExecuting
                      ? null
                      : _executeCode, // Disable button while executing
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: const Text('Execute Code'),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.black,
                  child: SingleChildScrollView(
                    child: Text(
                      output,
                      style: const TextStyle(
                        color: Colors.green,
                        fontFamily: 'Courier',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: _imageDataList.map((imageData) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.memory(
                        imageData,
                        width: 300,
                        height: 300,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          if (isExecuting)
            Container(
              color:
                  Colors.black.withOpacity(0.5), // Semi-transparent background
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
