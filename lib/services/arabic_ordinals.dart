ordinalsAr(int num,bool isFeminine){

  const feminineSuffix = "ة";

  final Map<int,Map> specialNums = {
    1:{
      "masculine": "الأول",
      "feminine": "الأولى"
    },
    10:{
      "masculine": "العاشر",
      "feminine": "العاشرة"
    }
  };

  final lastDigits = {
    10:"عشر",
    20:"العشرون",
    30:"الثلاثون",
    40:"الأربعون",
    50:"الخمسون",
    60:"الستون",
    70:"السبعون",
    80:"الثمانون",
    90:"التسعون",
    // you have to add the rest here
  };

  final firstDigits = {
    1:"الحادي",
    2:"الثاني",
    3:"الثالث",
    4:"الرابع",
    5:"الخامس",
    6:"السادس",
    7:"السابع",
    8:"الثامن",
    9:"التاسع",
  };

  if (specialNums.containsKey(num)) {
    return isFeminine ? specialNums[num]!['feminine'] : specialNums[num]!['masculine'];
  }

  if(firstDigits.containsKey(num)) {
    return isFeminine ? firstDigits[num]! + feminineSuffix : firstDigits[num];
  }

  if(lastDigits.containsKey(num)) {
    return lastDigits[num];
  }

  final firstDigit = num % 10;
  final lastDigit = num - firstDigit;

  if (isFeminine) {
    if(lastDigit < 20) {
      return "${firstDigits[firstDigit]}$feminineSuffix ${lastDigits[lastDigit]}$feminineSuffix";

    } else {
      return "${firstDigits[firstDigit]}$feminineSuffix و${lastDigits[lastDigit]}";
    }}

  else{
    if(lastDigit < 20) {
      return "${firstDigits[firstDigit]} ${lastDigits[lastDigit]}";
    }
  }

  return "${firstDigits[firstDigit]} و${lastDigits[lastDigit]}";
}