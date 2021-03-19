import 'dart:convert';
import 'package:fetch_list_test/Post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Post>> _fetchPosts() async {
    List<Post> posts = [];
    Http.Response response = await Http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    List data = json.decode(response.body);

    data.forEach((item) {
      posts.add(Post.fromJson(item));
    });
    return posts;
  }

  _post() async {
    Http.Response response = await Http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: {
        "Content-type": "application/json; charset=UTF-8"
      },
      body: json.encode({
        'userId': 130,
        'id': null,
        'title': 'item 123',
        'body': 'item 123'
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get data from list')
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text('Save'),
                  onPressed: _post
                ),
                ElevatedButton(
                  child: Text('Update'),
                  onPressed: () {}
                ),
                ElevatedButton(
                  child: Text('Delete'),
                  onPressed: () {}
                ),
              ]
            ),
            Expanded(
              child: FutureBuilder<List<Post>>(
                future: _fetchPosts(),
                builder: (context, snapshot) {
                  switch(snapshot.connectionState) {
                    case ConnectionState.done: {
                      if (snapshot.hasError) {
                        print('Lista: erro ao carregar');
                      }

                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          Post post = snapshot.data[index];
                          return ListTile(
                            title: Text(post.title),
                            subtitle: Text(post.body.substring(0, 50)),
                          );
                        }
                      );
                    }
                    case ConnectionState.none: {
                      break;
                    }
                    case ConnectionState.active: {
                      break;
                    }
                    case ConnectionState.waiting: {
                      return Center(child: CircularProgressIndicator());
                    }
                  }
                  return Text('Data');
                }
              )
            )
          ]
        )
      )
    );
  }
}
