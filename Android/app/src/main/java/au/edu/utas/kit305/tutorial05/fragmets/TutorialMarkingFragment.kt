package layout

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import au.edu.utas.kit305.tutorial05.*
import au.edu.utas.kit305.tutorial05.adapter.*
import au.edu.utas.kit305.tutorial05.data.Tutorial
import au.edu.utas.kit305.tutorial05.data.TutorialWeek
import au.edu.utas.kit305.tutorial05.databinding.FragmentTutorialMarkingBinding
import kotlin.math.roundToInt

class TutorialMarkingFragment : BaseFragment() {
    lateinit var ui: FragmentTutorialMarkingBinding

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        ui = FragmentTutorialMarkingBinding.inflate(layoutInflater, container, false)
        val bundle = arguments
        if (bundle != null) {
            val weekNo = bundle.getInt(B_WEEK_NO)
            val tuteType = bundle.getInt(B_TUTE_TYPE)
            val isUpdate = bundle.getBoolean(B_IS_UPDATE, false)
            var checksNo = 0
            var maxScore = 0
            if (tuteType == TUTE_CHECKPOINTS && bundle.containsKey(B_CHECKS_NO)) {
                checksNo = bundle.getInt(B_CHECKS_NO)
            } else if (tuteType == TUTE_SCORE && bundle.containsKey(B_MAX_SCORE)) {
                maxScore = bundle.getInt(B_MAX_SCORE)
            }
            val weeks = resources.getStringArray(R.array.week_select)
            val tutes = resources.getStringArray(R.array.tute_select)
            ui.txtTuteTitle.setText("Mark ${tutes[tuteType]} for ${weeks[weekNo]}")
            val list = mutableListOf<Tutorial>()
            if (isUpdate) {
                students.forEach { student ->
                    var tute =
                        tutorials[weekNo].list.find { item -> item.studentId.equals(student.id) }
                    if (tute == null) {
                        tute = Tutorial(
                            studentId = student.id,
                            studentName = student.name,
                            studentPic = student.photoURL
                        )
                        if (tuteType == TUTE_CHECKPOINTS) {
                            tute.checks = tutorials[weekNo].list[0].checks
                        } else if (tuteType == TUTE_SCORE) {
                            tute.maxScore = tutorials[weekNo].list[0].maxScore
                        }
                    } else {
                        tute.studentName = student.name
                        tute.studentPic = student.photoURL
                    }
                    list.add(tute)
                }
            } else {
                students.listIterator().forEach {
                    val tutorial =
                        Tutorial(
                            studentId = it.id,
                            studentName = it.name,
                            studentPic = it.photoURL
                        )
                    if (tuteType == TUTE_CHECKPOINTS) {
                        tutorial.checks = checksNo
                    } else if (tuteType == TUTE_SCORE) {
                        tutorial.maxScore = maxScore
                    }
                    list.add(tutorial)
                }
            }
            when (tuteType) {
                TUTE_ATTENDANCE -> {
                    ui.myList.adapter = AttendanceAdapter(list, act)
                }
                TUTE_CHECKPOINTS -> {
                    ui.myList.adapter = CheckpointAdapter(list, act)
                }
                TUTE_SCORE -> {
                    ui.myList.adapter = ScoreAdapter(list, act)
                }
                TUTE_GRADES -> {
                    ui.myList.adapter = GradesAdapter(list, act)
                }
                TUTE_GRADES_A_Z -> {
                    ui.myList.adapter = Grades_2Adapter(list, act)
                }
            }
            ui.saveBT.setOnClickListener {
                val tuteWeek = TutorialWeek(weekNo + 1, tuteType, list)
                tutorialCollection.whereEqualTo("weekNo", weekNo + 1)
                    .get()
                    .addOnSuccessListener {
                        if (it.isEmpty) {
                            tutorialCollection.add(tuteWeek)
                                .addOnSuccessListener {
                                    showToast("Week saved successfully")
                                }.addOnFailureListener {
                                    it.message?.let { it1 -> Log.e(FIREBASE_TAG, it1) }
                                    showToast("Something went wrong", true)
                                }
                        } else {
                            val doc = it.documents[0]
                            tutorialCollection.document(doc.id).update("list", list)
                                .addOnSuccessListener {
                                    showToast("Week updated successfully")
                                }.addOnFailureListener {
                                    it.message?.let { it1 -> Log.e(FIREBASE_TAG, it1) }
                                    showToast("Something went wrong", true)
                                }
                        }
                    }

            }
            Utils.setAverageListener {
                var totalScore = 0
                list.forEach { tutorial ->
                    totalScore += tutorial.totalMarks
                }
                ui.classAvgTV.text = "Class avg: ${(totalScore.toFloat() / list.size).roundToInt()}%"
            }
            Utils.doUpdate()
        }
        return ui.root
    }
}