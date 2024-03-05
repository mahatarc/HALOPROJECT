import 'package:flutter/material.dart';

class HelpAndSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help and Support',
        ),
        backgroundColor: Colors.green[100], // Green color added to app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'If you need any assistance or have any questions, feel free to contact us:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Email: haloapp59@gmail.com',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Phone: +977 9813590861',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                'FAQs',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Here are some frequently asked questions:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              FAQWidget(
                question: 'Q: How do I place an order?',
                answer:
                    'A: You can place an order by selecting the desired products and proceeding to checkout.',
              ),
              FAQWidget(
                question: 'Q: How do I update my account information?',
                answer:
                    'A: You can update your account information in the "My Profile" section.',
              ),
              FAQWidget(
                question: 'Q: What payment methods are accepted?',
                answer: 'A: We accept credit/debit cards and pay on delivery.',
              ),
              SizedBox(height: 20),
              Text(
                'Send a Message',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              MessageForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class FAQWidget extends StatelessWidget {
  final String question;
  final String answer;

  const FAQWidget({
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          answer,
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

class MessageForm extends StatefulWidget {
  @override
  _MessageFormState createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  final _formKey = GlobalKey<FormState>();
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Enter your message',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your message';
              }
              return null;
            },
            onSaved: (value) {
              _message = value!;
            },
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // Here you can send the message to your backend or perform any other action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Message sent'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[200],
            ),
            child: Text(
              'Send Message',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
