package au.edu.utas.kit305.tutorial05.adapter

import android.content.Context
import android.util.Log
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.RecyclerView
import au.edu.utas.kit305.tutorial05.FIREBASE_TAG
import au.edu.utas.kit305.tutorial05.R
import au.edu.utas.kit305.tutorial05.Utils
import au.edu.utas.kit305.tutorial05.data.Tutorial
import au.edu.utas.kit305.tutorial05.databinding.ItemCheckboxBinding
import au.edu.utas.kit305.tutorial05.databinding.ListItemCheckpointBinding
import com.bumptech.glide.Glide
import java.util.HashMap
import kotlin.math.roundToInt


class CheckpointAdapter(
    private val tutorials: MutableList<Tutorial>,
    private val context: Context
) :
    RecyclerView.Adapter<CheckpointAdapter.Holder>() {
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): Holder {
        val ui = ListItemCheckpointBinding.inflate(
            LayoutInflater.from(context),
            parent,
            false
        )

        return Holder(ui)
    }

    override fun getItemCount(): Int {
        return tutorials.size
    }

    override fun onBindViewHolder(holder: Holder, position: Int) {
        val tute = tutorials[position]   //get the data at the requested position
        holder.ui.nameTV.text = tute.studentName
        holder.ui.stuIDTV.text = tute.studentId
        Glide.with(context).load(tute.studentPic)
            .placeholder(ContextCompat.getDrawable(context, R.drawable.ic_user))
            .circleCrop()
            .into(holder.ui.picIV)
        holder.ui.checkGL.removeAllViews()
        for (i in 1..tute.checks) {
            val uiItem = ItemCheckboxBinding.inflate(LayoutInflater.from(context))
            uiItem.checkCB.text = "Checkbox $i"
            uiItem.checkCB.setOnCheckedChangeListener { buttonView, isChecked ->
                tute.checksList.put(i.toString(), isChecked)
                tute.totalMarks = totalScore(tute.checksList, tute.checks)
                Log.d(FIREBASE_TAG, "Total marks: ${tute.totalMarks}")
                Utils.doUpdate()
            }
            if (tute.checksList.containsKey(i.toString())) {
                uiItem.checkCB.isChecked = tute.checksList[i.toString()]!!
            }
            holder.ui.checkGL.addView(uiItem.root)
        }
    }

    private fun totalScore(
        checksList: HashMap<String, Boolean>,
        checks: Int
    ): Int {
        var totalScore = 0
        var count = 0
        checksList.forEach {
            if (it.value) {
                count++
            }
        }
        totalScore = (count * 100f / checks.toFloat()).roundToInt()
        return totalScore
    }

    inner class Holder(var ui: ListItemCheckpointBinding) : RecyclerView.ViewHolder(ui.root)
}