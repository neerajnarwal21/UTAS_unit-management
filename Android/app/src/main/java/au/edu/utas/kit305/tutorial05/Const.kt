package au.edu.utas.kit305.tutorial05

import au.edu.utas.kit305.tutorial05.data.Student
import au.edu.utas.kit305.tutorial05.data.TutorialWeek
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import com.google.firebase.storage.ktx.storage

const val B_WEEK_NO = "week_no"
const val B_TUTE_TYPE = "tute_type"
const val B_CHECKS_NO = "checks_no"
const val B_MAX_SCORE = "max_score"
const val B_IS_UPDATE = "is_update"
const val B_STUDENT_ID = "student_id"

const val TUTE_ATTENDANCE = 0
const val TUTE_CHECKPOINTS = 1
const val TUTE_SCORE = 2
const val TUTE_GRADES = 3
const val TUTE_GRADES_A_Z = 4

const val REQUEST_IMAGE_CAPTURE = 1

val db = Firebase.firestore
val storage = Firebase.storage
var tutorialCollection = db.collection("tutorial")
var studentsCollection = db.collection("students")

val students = mutableListOf<Student>()
val tutorials = mutableListOf<TutorialWeek>()
const val FIREBASE_TAG = "FirebaseLogging"