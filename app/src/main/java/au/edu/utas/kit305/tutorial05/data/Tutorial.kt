package au.edu.utas.kit305.tutorial05.data


class Tutorial(
    var studentId: String? = null,
    var studentName: String? = null,
    var studentPic: String? = null,
    var totalMarks:Int = 0,
    var isAttendance: Boolean = false,
    var checks: Int = 0,
    var checksList: HashMap<String, Boolean> = hashMapOf(),
    var score: Int = 0,
    var maxScore: Int = 0,
    var grades: Int = 0,
    var grades2: Int = 0
)