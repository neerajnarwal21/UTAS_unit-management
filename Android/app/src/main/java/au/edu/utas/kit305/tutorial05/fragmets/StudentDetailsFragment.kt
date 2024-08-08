package layout

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.appcompat.app.AlertDialog
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.RecyclerView
import au.edu.utas.kit305.tutorial05.*
import au.edu.utas.kit305.tutorial05.data.Student
import au.edu.utas.kit305.tutorial05.data.StudentGrades
import au.edu.utas.kit305.tutorial05.databinding.FragmentStudentDetailsBinding
import au.edu.utas.kit305.tutorial05.databinding.ListItemStudentTuteBinding
import com.bumptech.glide.Glide
import com.google.firebase.firestore.ktx.toObject
import kotlin.math.roundToInt

class StudentDetailsFragment : BaseFragment() {

    lateinit var ui: FragmentStudentDetailsBinding

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        ui = FragmentStudentDetailsBinding.inflate(layoutInflater, container, false)
        val bundle = arguments
        if (bundle != null) {
            val studentId = bundle.getString(B_STUDENT_ID)
            val student = students.find { student -> studentId.equals(student.id) }
            if (student != null) {
                ui.txtName.text = student.name
                ui.txtStudentID.text = student.id
                Glide.with(act).load(student.photoURL)
                    .placeholder(ContextCompat.getDrawable(act, R.drawable.ic_user))
                    .circleCrop()
                    .into(ui.stuIV)
                val list = mutableListOf<StudentGrades>()
                var totalMarks = 0
                tutorials.forEach { tuteWeek ->
                    val tute = tuteWeek.list.find { tute -> tute.studentId.equals(studentId) }
                    totalMarks += tute?.totalMarks ?: 0
                    list.add(
                        StudentGrades(
                            weekNo = tuteWeek.weekNo,
                            tuteType = tuteWeek.tuteType,
                            totalMarks = tute?.totalMarks ?: 0
                        )
                    )
                }

                var avgMarks = 0
                if (tutorials.size > 0)
                    avgMarks = (totalMarks.toFloat() / tutorials.size).roundToInt()
                ui.txtWeek.text = "${act.resources.getString(R.string.weekly_details)} (Avg: $avgMarks%)"
                ui.myList.adapter = StudentGradesAdapter(list)
                ui.editIV.setOnClickListener {
                    val frag = StudentAddFragment()
                    val bndl = Bundle()
                    bndl.putBoolean(B_IS_UPDATE, true)
                    bndl.putString(B_STUDENT_ID, studentId)
                    frag.arguments = bndl
                    act.supportFragmentManager
                        .beginTransaction()
                        .replace(R.id.frame_container, frag)
                        .addToBackStack(null)
                        .commit()
                }
                ui.deleteIV.setOnClickListener {
                    val alert = AlertDialog.Builder(act)
                    alert.setTitle("Delete student !")
                    alert.setMessage("Are you sure you want to delete this student?")
                    alert.setPositiveButton("Delete") { dialog, which ->
                        act.backEnable = false
                        studentsCollection.whereEqualTo("id", student.id)
                            .get()
                            .addOnSuccessListener {
                                val doc = it.documents[0]
                                studentsCollection.document(doc.id).update("active", 0)
                                    .addOnSuccessListener {
                                        //Reload student list once to update student collection list
                                        studentsCollection
                                            .orderBy("id")
                                            .get()
                                            .addOnSuccessListener {
                                                students.clear()
                                                for (document in it) {
                                                    val stu = document.toObject<Student>()
                                                    Log.d(FIREBASE_TAG, stu.toString())
                                                    if (stu.active == 1)
                                                        students.add(stu)
                                                    showToast("Student deleted successfully")
                                                    act.supportFragmentManager.popBackStack()
                                                }
                                            }
                                        act.backEnable = true
                                    }.addOnFailureListener {
                                        it.message?.let { it1 -> Log.e(FIREBASE_TAG, it1) }
                                        showToast("Something went wrong", true)
                                        act.backEnable = true
                                    }

                            }
                    }
                    alert.setNegativeButton("Cancel") { dialog, which ->
                        dialog.dismiss()
                    }
                    alert.create().show()
                }
                ui.shareIV.setOnClickListener {
                    var string = ""
                    string += "Name: ${student.name}, Student ID: ${student.id} Avg: $avgMarks\n Marks: "
                    list.forEach {
                        string += "Week ${it.weekNo}=${it.totalMarks}, "
                    }
                    string = string.substring(0, string.length - 2)
                    Log.d(FIREBASE_TAG, string)
                    val sendIntent: Intent = Intent().apply {
                        action = Intent.ACTION_SEND
                        putExtra(Intent.EXTRA_TEXT, string)
                        type = "text/plain"
                    }
                    val shareIntent = Intent.createChooser(sendIntent, null)
                    startActivity(shareIntent)
                }
            } else {
                showToast("Something went wrong")
            }
        }
        return ui.root
    }

    inner class Holder(var ui: ListItemStudentTuteBinding) : RecyclerView.ViewHolder(ui.root)

    inner class StudentGradesAdapter(private val grades: List<StudentGrades>) :
        RecyclerView.Adapter<Holder>() {

        val weekList = act.resources.getStringArray(R.array.week_select)
        val tutes = act.resources.getStringArray(R.array.tute_select)
        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): Holder {
            val ui = ListItemStudentTuteBinding.inflate(
                layoutInflater,
                parent,
                false
            )
            return Holder(ui)
        }

        override fun getItemCount(): Int {
            return grades.size
        }

        override fun onBindViewHolder(holder: Holder, position: Int) {
            val grade = grades[position]
            holder.ui.weekNameTV.text = weekList[grade.weekNo - 1]
            holder.ui.tuteTypeTV.text = tutes[grade.tuteType]
            holder.ui.scoreTV.text = "Score: ${grade.totalMarks}"
        }
    }
}