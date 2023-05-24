class Profile {
  String name;
  String nim;
  String plug;

  Profile({required this.name, this.nim = '', this.plug = 'IF - B'});
}

List<Profile> profiles = [
  Profile(name: 'Muhammad Handi Rachmawan', nim: '123200125'),
  Profile(name: 'Muhammad Rizky Susanto', nim: '123200145'),
];
