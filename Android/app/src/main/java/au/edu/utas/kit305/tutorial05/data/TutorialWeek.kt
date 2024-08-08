package au.edu.utas.kit305.tutorial05.data


class TutorialWeek(
    var weekNo: Int = 0,
    var tuteType: Int = 0,
    var list: MutableList<Tutorial> = mutableListOf()
)