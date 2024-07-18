
class AppUser {
  String long;
  String lat;
  String image;
  String name;

  AppUser({required this.long, required this.lat, required this.image, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'long': long,
      'lat': lat,
      'image': image,
      'name': name,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json, String docId) {
    return AppUser( name: json['name']??'Unknown', long: json['long']??'Unknown',lat: json['lat']??"Hatolik",image: json['image']??"hatolik");




  }
}
