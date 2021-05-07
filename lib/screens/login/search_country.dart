import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hagglex_flutter/screens/login/signup.dart';

class StartHere1 extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    // We're using HiveStore for persistence,
    // so we need to initialize Hive.
//    await initHiveForFlutter();

    final HttpLink httpLink =
    HttpLink('https://countries.trevorblades.com/');

    ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: httpLink as Link,

        // The default store is the InMemoryStore, which does NOT persist to disk
        cache: GraphQLCache(store: HiveStore()),
//        cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject,
        ),
      );

    return GraphQLProvider(
      child: CountryListView(),
      client: client,
    );
  }
}


class CountryListView extends StatefulWidget {
  @override
  _CountryListViewState createState() => _CountryListViewState();
}

class _CountryListViewState extends State<CountryListView> {

  List<UserDetails> myCountries = List<UserDetails>();
  var duplicateItems = [];
  TextEditingController editingController = TextEditingController();

  final String query = '''
                      query ReadCountries {
                          countries {
                            name
                            phone
                            emoji
                          }
                      }
                  ''';

  void filterSearchResults(String query) {
    var dummySearchList = [];
    dummySearchList.addAll(myCountries);
    print('Countries');
    print(myCountries);
    if(query.isNotEmpty) {
      List<UserDetails> dummyListData = List<UserDetails>();
      for (var i = 0; i < myCountries.length; i++) {
        if(myCountries[i].name.contains(query)) {
          dummyListData.add(myCountries[i]);
          print('Tiri mu IF');
          print(myCountries[i].name);
        }else{
//          print('Tiri mu Else');
//          print(myCountries[i].name);
        }
      }
      setState(() {
        myCountries.clear();
        myCountries.addAll(dummyListData);
      });
      return;
    } else {
//      setState(() {
//        myCountries.clear();
//        myCountries.addAll(duplicateItems);
//      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2b2350),
//      appBar: AppBar(
//        title: Text(''),
//        elevation: 0,
//        automaticallyImplyLeading: false,
//      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  style: TextStyle(fontSize: 12),
                  onChanged: (value) {
                    filterSearchResults(value);},
                  controller: editingController,
                  decoration: InputDecoration(
                    hintText: "Search for country",
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    fillColor: Colors.white.withOpacity(0.4),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Divider(
                height: 2,
                color: Colors.white.withOpacity(0.4),
              ),
              Expanded(
                child: Query(
                  options: QueryOptions(
                      document: gql(query)),
                  builder: (QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {
                    if (result.loading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (result.data == null) {
                      return Center(child: Text('Countries not found.'));
                    }

                    return _countriesView(result);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListView _countriesView(QueryResult result) {
    final countryList = result.data['countries'];

    for (var i = 0; i < countryList.length; i++) {
      myCountries.add(
        UserDetails(
          name: countryList[i]['name'],
          phone: countryList[i]['phone'],
          emoji: countryList[i]['emoji'],
        )
      );
    }
    return ListView.separated(
      itemCount: countryList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('[+${myCountries[index].phone}] ' + myCountries[index].name, style: TextStyle(
            color: Colors.white,
          ),),
//          subtitle: Text('Currency: ${countryList[index]['phone']}'),
          leading: Text(myCountries[index].emoji),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen(flagCountry: myCountries[index].emoji,code: myCountries[index].phone, submitted: true, )));
            final snackBar = SnackBar(
                content:
                Text('Selected Country: ${myCountries[index].name}'));
            Scaffold.of(context).showSnackBar(snackBar);
          },
        );
      },
      separatorBuilder: (context, index) {
        return Divider(color: Colors.white.withOpacity(0),);
      },
    );

  }
}

class UserDetails {

  final String name, phone, emoji;

  UserDetails({
      this.name,
      this.phone,
      this.emoji
  });


}