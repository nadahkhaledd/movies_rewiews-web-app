import 'package:flutter/material.dart';
import 'package:movies_reviews/API/APImanager.dart';
import 'package:movies_reviews/items/reviewItem.dart';
import 'package:movies_reviews/models/Movie.dart';
import 'package:movies_reviews/models/Review.dart';
import 'package:movies_reviews/models/ReviewsResponse.dart';

class reviewsPage extends StatefulWidget {
  late Movie movie;
  reviewsPage(this.movie);
  @override
  State<reviewsPage> createState() => _reviewsPageState();
}

class _reviewsPageState extends State<reviewsPage> {
  late Future<ReviewsResponse> reviewsFuture;

  @override
  void initState() {
    super.initState();
    reviewsFuture = getAllReviews();
  }

  @override
  Widget build(BuildContext context) {
    List<Review> reviewsRelated = [];
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Center(
            child: Text(
              "Movies reviews",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Container(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(14.0),
                        child: Image.asset("assets/images/movies.jpg",
                            height: MediaQuery.of(context).size.height/4, width: MediaQuery.of(context).size.width/8)
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.movie.name??" ",
                        textAlign: TextAlign.center,
                        style:
                        TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Reviews",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.blueGrey),),
              ),
              FutureBuilder<ReviewsResponse>(
                future: reviewsFuture,
                  builder: (buildContext, snapshot) {
                  if(snapshot.hasData)
                    {
                      for(int i=0; i<snapshot.data!.list.length; i++)
                        {
                          if(snapshot.data!.list[i].movieId == widget.movie.id)
                            {
                              reviewsRelated.add(snapshot.data!.list[i]);
                            }

                        }
                      return Container(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          shrinkWrap: true,
                          itemBuilder: (buildContext, index) =>
                              Expanded(child: reviewItem(reviewsRelated[index], context)),
                          itemCount: reviewsRelated.length,
                        ),
                      );
                    }
                  else if(snapshot.hasError)
                    {
                      print(snapshot.error);
                    }

                    return Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ));

    }
              )
            ],
          ),
        ));
  }
}

