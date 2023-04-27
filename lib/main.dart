import 'dart:convert'; // for jsonDecode
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import 'keys.dart';

void main(List<String> args) {
  runApp(const MaterialApp(home: MoviesList()));
}

List<Movie> myMovies = [];

class MoviesList extends StatefulWidget {
  const MoviesList({super.key});

  @override
  State<MoviesList> createState() => _MoviesListState();
}

class _MoviesListState extends State<MoviesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red[800],
          title: Row(
            children: const [
              Icon(Icons.movie_filter, color: Colors.white),
              Text(' Cornflix', style: TextStyle(fontSize: 30, color: Colors.white)),
            ],
          )),
      backgroundColor: Colors.black87,
      body: ListView.builder(
        itemCount: myMovies.isEmpty ? 1 : myMovies.length,
        itemBuilder: (BuildContext context, int index) {
          if (myMovies.isEmpty) {
            return Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(20),
              color: Colors.black87,
              height: 120.0,
              child: Card(
                elevation: 8.0,
                margin: const EdgeInsets.all(10),
                color: Colors.black87,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Nothing here yet :)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.red[800],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Dismissible(
              key: ValueKey<String>(myMovies[index].getTitle() + myMovies[index].getYear().toString()),
              child: ListTile(
                leading: Image.network(myMovies[index].getImageUrl()),
                title: Text(
                  myMovies[index].getTitle(),
                  style: const TextStyle(color: Colors.white, fontSize: 30),
                ),
                subtitle: Text("${myMovies[index].getYear()}  -  ${myMovies[index].getRate()}", style: TextStyle(color: Colors.red[800])),
                dense: true,
                trailing: Text(
                  "${myMovies[index].getStars()} ⭐",
                  style: TextStyle(color: Colors.yellow[700], fontSize: 30),
                ),
                iconColor: Colors.red,
              ),
              confirmDismiss: (DismissDirection direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirm", style: TextStyle(color: Colors.white)),
                      content: const Text("Are you sure you wish to remove this item?", style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.red[900],
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
                          child: const Text("DELETE"),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                          child: const Text("CANCEL"),
                        ),
                      ],
                    );
                  },
                );
              },
              onDismissed: (direction) => setState(() {
                myMovies.removeWhere((e) => e.getTitle() == myMovies[index].getTitle() && e.getYear() == myMovies[index].getYear());
              }),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMovie()));
        },
        backgroundColor: Colors.red[700],
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddMovie extends StatefulWidget {
  const AddMovie({super.key});

  @override
  State<AddMovie> createState() => _AddMovieState();
}

class _AddMovieState extends State<AddMovie> {
  TextEditingController title = TextEditingController();
  TextEditingController year = TextEditingController();
  TextEditingController stars = TextEditingController();
  TextEditingController url = TextEditingController();
  Rate rate = Rate.pg;
  List<DropdownMenuItem<Movie>> searchResult = [
    const DropdownMenuItem(value: null, child: Text("Empty")),
  ];
  TextEditingController maxRes = TextEditingController(text: "5");
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[700],
          title: Row(
            children: const [
              Icon(Icons.movie_filter, color: Colors.white),
              Text(" Cornflix", style: TextStyle(fontSize: 30, color: Colors.white)),
            ],
          ),
        ),
        body: Container(
          color: Colors.black87,
          child: Column(children: [
            const Text("Add Movie", style: TextStyle(color: Colors.white, fontSize: 30)),
            const SizedBox(height: 20),
            const Text("Title", style: TextStyle(color: Colors.white, fontSize: 20)),
            const SizedBox(height: 10),
            TextField(
              controller: title,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2.0)),
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                // hintText: "Title",
                label: const Text("Title", style: TextStyle(color: Colors.white)),
                icon: Icon(Icons.title, color: Colors.red[700]),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red[700]!)),
                    onPressed: () => search(title.text),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [Icon(Icons.saved_search), Icon(Icons.arrow_downward)],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextField(
                    controller: maxRes,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2.0)),
                      border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                      label: const Text("Max Results", style: TextStyle(color: Colors.white)),
                      hintStyle: const TextStyle(color: Colors.white),
                      icon: Icon(Icons.numbers, color: Colors.red[700]),
                    ),
                  ),
                )
              ],
            ),
            DropdownButton(
              value: null,
              items: searchResult,
              onChanged: (value) => setState(() {
                title = TextEditingController(text: value?.getTitle());
                year = TextEditingController(text: value?.getYear().toString());
                stars = TextEditingController(text: value?.getStars().toString());
                url = TextEditingController(text: value?.getImageUrl());
                rate = Rate.pg;
              }),
              style: const TextStyle(color: Colors.white),
              dropdownColor: Colors.black87,
            ),
            const Text("Year", style: TextStyle(color: Colors.white, fontSize: 20)),
            const SizedBox(height: 10),
            TextField(
              controller: year,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2.0)),
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                label: const Text("Year", style: TextStyle(color: Colors.white)),
                icon: Icon(Icons.date_range, color: Colors.red[700]),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Stars", style: TextStyle(color: Colors.white, fontSize: 20)),
            const SizedBox(height: 10),
            TextField(
              controller: stars,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2.0)),
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                hintText: "/10",
                hintStyle: const TextStyle(color: Colors.white60),
                label: const Text("Stars", style: TextStyle(color: Colors.white)),
                icon: Icon(Icons.star, color: Colors.red[700]),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Image URL", style: TextStyle(color: Colors.white, fontSize: 20)),
            const SizedBox(height: 10),
            TextField(
              controller: url,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2.0)),
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                hintText: "Image URL",
                label: const Text("Image URL", style: TextStyle(color: Colors.white)),
                icon: Icon(Icons.image, color: Colors.red[700]),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Rate", style: TextStyle(color: Colors.white, fontSize: 20)),
            const SizedBox(height: 10),
            DropdownButton<Rate>(
              value: rate,
              icon: const Icon(Icons.arrow_downward, color: Colors.red),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.black87),
              underline: Container(
                height: 2,
                color: Colors.red,
              ),
              dropdownColor: Colors.black87,
              onChanged: (Rate? newValue) {
                setState(() => rate = newValue!);
              },
              items: Rate.values.map<DropdownMenuItem<Rate>>((Rate value) {
                return DropdownMenuItem<Rate>(
                  value: value,
                  child: Text(value.name, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (title.text == "" || year.text == "" || stars.text == "") {
                  // not working ? why???
                  setState(() {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all the fields")));
                  });
                  return;
                }
                Movie m = Movie(
                  title1: title.text,
                  year1: int.parse(year.text),
                  url1: url.text,
                  stars1: double.parse(stars.text),
                  rate1: rate,
                );
                myMovies.add(m);
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MoviesList()));
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red[700]!)),
              child: const Text("Add"),
            ),
          ]),
        ),
      ),
    );
  }

  void search(query) async {
    if (query == "") {
      searchResult = [];
      return;
    }
    String url = "https://api.themoviedb.org/3/search/multi?api_key=$API_KEY&language=en-US&page=1&include_adult=false&query=$query";
    http.Response response = await fetch(url);

    Map<String, dynamic> res = json.decode(response.body);
    displaySearchList(res);
  }

  Future<http.Response> fetch(String url) {
    return http.get(
      Uri.parse(url),
    );
  }

  void displaySearchList(Map<String, dynamic> res) {
    List data = res["results"];
    searchResult = [];
    int max = int.parse(maxRes.text);
    for (var i = 0; i < data.length && i < max; i++) {
      if (data[i]["media_type"] == "person") {
        max++;
        continue;
      }
      String title = data[i]["media_type"] == 'movie' ? data[i]["title"] : data[i]["name"];
      int year;
      year = data[i]["media_type"] == 'movie'
          ? data[i]['release_date'] == ''
              ? 0
              : int.parse(data[i]["release_date"].split("-")[0])
          : data[i]["first_air_date"] == ''
              ? 0
              : int.parse(data[i]["first_air_date"].split("-")[0]);

      double stars = data[i]["vote_average"];
      String url = "https://image.tmdb.org/t/p/w200${data[i]['poster_path'] ?? "/yk4J4aewWYNiBhD49WD7UaBBn37.jpg"}";
      if (title.length > 50) title = "${title.substring(0, 50)}...";
      DropdownMenuItem<Movie> movie = DropdownMenuItem<Movie>(
        value: Movie(title1: title, year1: year, stars1: stars, url1: url, rate1: Rate.pg),
        child: Container(
          color: Colors.red[700],
          child: Row(
            children: [
              Image.network(url),
              Text(" $title ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text(year.toString()),
            ],
          ),
        ),
      );
      searchResult.add(movie);
    }

    setState(() {
      searchResult = searchResult;
    });
  }
}

class Movie {
  late String _title;
  late int _year;
  late double _stars;
  late String _imageUrl;
  late Rate _rate = Rate.pg;

  Movie({title1, year1, stars1, url1, rate1}) {
    _title = title1;
    _year = year1;
    _imageUrl = url1 == "" ? "https://image.tmdb.org/t/p/w500/iBXsm2VuTLdocOWUHSKjie8fjlU.jpg" : url1;
    _stars = stars1 > 10 ? 10 : stars1;
    _rate = rate1;
  }
  // generate getters and setters
  String getTitle() {
    return _title;
  }

  void setTitle(String title1) {
    _title = title1;
  }

  int getYear() {
    return _year;
  }

  void setYear(int year1) {
    _year = year1;
  }

  double getStars() {
    return _stars;
  }

  void setStars(double stars1) {
    _stars = stars1 > 10 ? 10 : stars1;
  }

  String getImageUrl() {
    return _imageUrl;
  }

  void setImageUrl(String url1) {
    _imageUrl = url1;
  }

  String getRate() {
    return _rate.name;
  }

  void setRateAsString(String rate1) {
    _rate = Rate.values.firstWhere((e) => e.name == rate1);
  }

  void setRate(Rate rate1) {
    _rate = rate1;
  }

  @override
  String toString() {
    return "Title: $_title, Year: $_year, Stars: $_stars, ImageUrl: $_imageUrl, Rate: $_rate";
  }
}

enum Rate { pg, pg13, r, g }


// https://image.tmdb.org/t/p/w500/wwemzKWzjKYJFfCeiB57q3r4Bcm.png