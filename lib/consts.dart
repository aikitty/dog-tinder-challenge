const int kAnimationDuration = 500;
const int kAnimationDelayIncrement = 100;

enum Status { none, skipped, liked, disliked }

// Based on rescue dog personality types: https://nhhumane.org/adopt/meet-your-match/dogs
const List kProfiles = [
  {'personality': 'Couch Potato', 'profile': 'Netflix and snacks.'},
  {
    'personality': 'Constant Companion',
    'profile': 'Loves long walks on the beach.'
  },
  {'personality': 'Teacher\'s Pet', 'profile': 'Loyal and loving.'},
  {
    'personality': 'Go Getter',
    'profile': 'Known to pop a squat in the woods from time to time.'
  },
  {
    'personality': 'Life of the Party',
    'profile': 'Strangers are just friends you haven\'t met yet.'
  },
  {'personality': 'Free Spirit', 'profile': 'Looking for a partner in crime.'},
  {
    'personality': 'Wallflower',
    'profile': 'Shy at first but I\'m worth the effort!'
  },
  {'personality': 'Busy Bee', 'profile': 'Work hard play hard!'},
  {
    'personality': 'Goofball',
    'profile': 'Here for a good time AND a long time!'
  },
];
