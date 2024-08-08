package layout

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.SearchView
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import au.edu.utas.kit305.tutorial05.*
import au.edu.utas.kit305.tutorial05.data.Student
import au.edu.utas.kit305.tutorial05.data.StudentGrades
import au.edu.utas.kit305.tutorial05.databinding.FragmentStudentBinding
import au.edu.utas.kit305.tutorial05.databinding.ListItemStudentBinding
import com.bumptech.glide.Glide
import com.google.firebase.firestore.ktx.toObject
import kotlin.math.roundToInt

class StudentListFragment : BaseFragment() {

    lateinit var ui: FragmentStudentBinding
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        ui = FragmentStudentBinding.inflate(layoutInflater, container, false)
        ui.myList.adapter = StudentAdapter(students = students)
        ui.myList.layoutManager = LinearLayoutManager(act)
        studentsCollection
            .orderBy("id")
            .get()
            .addOnSuccessListener {
                students.clear()
                for (document in it) {
                    val student = document.toObject<Student>()
                    Log.d(FIREBASE_TAG, student.toString())
                    if (student.active == 1)
                        students.add(student)
                    (ui.myList.adapter as StudentAdapter).notifyDataSetChanged()
                }

            }.addOnCompleteListener {
                if (it.result?.isEmpty!!) {
                    ui.txtNoStudent.visibility = View.VISIBLE
                }
            }
        ui.addStudentFAB.setOnClickListener {
            act.supportFragmentManager
                .beginTransaction()
                .replace(R.id.frame_container, StudentAddFragment())
                .addToBackStack(null)
                .commit()
        }
        ui.searchSV.setOnQueryTextListener(object : SearchView.OnQueryTextListener,
            androidx.appcompat.widget.SearchView.OnQueryTextListener {
            override fun onQueryTextSubmit(query: String?): Boolean {
                TODO("Not yet implemented")
            }

            override fun onQueryTextChange(newText: String?): Boolean {
                val list: List<Student> = students.filter { student ->
                    student.name!!.contains(newText ?: "", true) || student.id!!.contains(newText ?: "")
                }
                ui.myList.adapter = StudentAdapter(list)
                return true
            }

        })
        return ui.root
    }

    inner class StudentHolder(var ui: ListItemStudentBinding) : RecyclerView.ViewHolder(ui.root)

    inner class StudentAdapter(private val students: List<Student>) :
        RecyclerView.Adapter<StudentHolder>() {
        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): StudentHolder {
            val ui = ListItemStudentBinding.inflate(
                layoutInflater,
                parent,
                false
            )
            return StudentHolder(ui)
        }

        override fun getItemCount(): Int {
            return students.size
        }

        override fun onBindViewHolder(holder: StudentHolder, position: Int) {
            val student = students[position]
            holder.ui.nameTV.text = student.name
            holder.ui.stuIDTV.text = student.id
            var totalScore = 0
            tutorials.forEach { tuteWeek ->
                val tute = tuteWeek.list.find { tute -> tute.studentId.equals(student.id) }
                totalScore += tute?.totalMarks ?: 0
            }
            if (tutorials.size > 0)
                holder.ui.stuAvgTV.text =
                    "Avg: ${(totalScore.toFloat() / tutorials.size).roundToInt()}%"
            Glide.with(act).load(student.photoURL)
                .placeholder(ContextCompat.getDrawable(act, R.drawable.ic_user))
                .circleCrop()
                .into(holder.ui.picIV)

            holder.ui.root.setOnClickListener {
                val frag = StudentDetailsFragment()
                val bundle = Bundle()
                bundle.putString(B_STUDENT_ID, student.id)
                frag.arguments = bundle
                act.supportFragmentManager
                    .beginTransaction()
                    .replace(R.id.frame_container, frag)
                    .addToBackStack(null)
                    .commit()
            }
        }
    }
}