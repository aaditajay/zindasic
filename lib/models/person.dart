class Person {
  final String id;
  final String name;
  final String favoriteSong;
  final String quote;
  final String avatarSeed;

  Person({
    required this.id,
    required this.name,
    required this.favoriteSong,
    required this.quote,
    required this.avatarSeed,
  });
}

final List<Person> mockPeople = [
  Person(
    id: '1',
    name: 'Aadit Ajay',
    favoriteSong: 'Kattuchembakam',
    quote: 'A song that feels like home.',
    avatarSeed: 'aadit',
  ),
  Person(
    id: '2',
    name: 'Ajin Santhosh',
    favoriteSong: 'Pularan Neram',
    quote: 'A song that feels like home.',
    avatarSeed: 'ajin',
  ),
  Person(
    id: '3',
    name: 'Milan Roy',
    favoriteSong: 'Vellaratharam',
    quote: 'Reminds me of our long drives.',
    avatarSeed: 'milan',
  ),
  Person(
    id: '4',
    name: 'Anjali Nair',
    favoriteSong: 'Uyire',
    quote: 'A soft corner for the people we miss.',
    avatarSeed: 'anjali',
  ),
  Person(
    id: '5',
    name: 'Aravind Swamy',
    favoriteSong: 'Aaromal',
    quote: 'Pure nostalgia in every note.',
    avatarSeed: 'aravind',
  ),
];
