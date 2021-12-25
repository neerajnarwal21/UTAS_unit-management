package layout

import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.RecyclerView
import au.edu.utas.kit305.tutorial05.*
import au.edu.utas.kit305.tutorial05.data.TutorialWeek
import au.edu.utas.kit305.tutorial05.databinding.FragmentTutorialHomeBinding
import au.edu.utas.kit305.tutorial05.databinding.ListItemTutorialHomeBinding
import com.bumptech.glide.Glide
import com.google.firebase.firestore.ktx.toObject
import kotlin.math.roundToInt

class TutorialListFragment : BaseFragment() {

    lateinit var ui: FragmentTutorialHomeBinding
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        ui = FragmentTutorialHomeBinding.inflate(layoutInflater, container, false)
        ui.myList.adapter = TutorialAdapter(tutorials, act)
        tutorialCollection.orderBy("weekNo")
            .get()
            .addOnSuccessListener {
                tutorials.clear()
                for (document in it) {
                    val tutorialWeek = document.toObject<TutorialWeek>()
                    Log.d(FIREBASE_TAG, tutorialWeek.toString())
//                    val listIndexes = mutableListOf<Int>()
//                    listIndexes.clear()
//                    tutorialWeek.list.forEachIndexed { index, tutorial ->
//                        val student =
//                            students.find { student -> tutorial.studentId.equals(student.id) }
//                        if (student == null) {
//                            listIndexes.add(index)
//                        }
//                    }
//                    if (listIndexes.size > 0) {
//                        listIndexes.forEach {
//                            tutorialWeek.list.removeAt(it)
//                        }
//                    }
                    tutorials.add(tutorialWeek)
                    (ui.myList.adapter as TutorialAdapter).notifyDataSetChanged()
                }

            }.addOnCompleteListener {
                if (it.result?.isEmpty!!) {
                    ui.txtNoTutorial.visibility = View.VISIBLE
                }
            }
        ui.addTutorialFAB.setOnClickListener {
            if (students.size > 0) {
                act.supportFragmentManager
                    .beginTransaction()
                    .replace(R.id.frame_container, TutorialAddFragment())
                    .addToBackStack(null)
                    .commit()
            } else {
                showToast("No student record found. Kindly add student in the system")
            }
        }
        return ui.root
    }

    inner class TutorialHolder(var ui: ListItemTutorialHomeBinding) :
        RecyclerView.ViewHolder(ui.root) {}

    inner class TutorialAdapter(
        private val weeks: MutableList<TutorialWeek>,
        private val act: MainActivity
    ) :
        RecyclerView.Adapter<TutorialHolder>() {
        val weekList = act.resources.getStringArray(R.array.week_select)
        val tutes = act.resources.getStringArray(R.array.tute_select)
        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): TutorialHolder {
            val ui = ListItemTutorialHomeBinding.inflate(
                layoutInflater,
                parent,
                false
            )
            return TutorialHolder(ui)
        }

        override fun getItemCount(): Int {
            return weeks.size
        }

        override fun onBindViewHolder(holder: TutorialHolder, position: Int) {
            val week = weeks[position]
            holder.ui.weekNameTV.setText(weekList[week.weekNo - 1])
            holder.ui.tuteTypeTV.setText(tutes[week.tuteType])
            var totalScore = 0
            week.list.forEach { tutorial ->
                totalScore += tutorial.totalMarks
            }
            holder.ui.classAvgTV.text =
                "Class avg: ${(totalScore.toFloat() / week.list.size).roundToInt()}%"
            holder.ui.root.setOnClickListener {
                val bundle = Bundle()
                bundle.putInt(B_WEEK_NO, week.weekNo - 1)
                bundle.putInt(B_TUTE_TYPE, week.tuteType)
                bundle.putBoolean(B_IS_UPDATE, true)
                val frag = TutorialMarkingFragment()
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