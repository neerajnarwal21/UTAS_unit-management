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
import au.edu.utas.kit305.tutorial05.databinding.ListItemAttendanceBinding
import com.bumptech.glide.Glide


class AttendanceAdapter(
    private val tutorials: MutableList<Tutorial>,
    private val context: Context
) :
    RecyclerView.Adapter<AttendanceAdapter.Holder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): Holder {
        val ui = ListItemAttendanceBinding.inflate(
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
        holder.ui.attendanceCB.setOnCheckedChangeListener { _, isChecked ->
            tute.isAttendance = isChecked
            tute.totalMarks = if(isChecked) 100 else 0
            Log.d(FIREBASE_TAG, tute.totalMarks.toString())
            Utils.doUpdate()
        }
        holder.ui.attendanceCB.isChecked = tute.isAttendance
    }

    inner class Holder(var ui: ListItemAttendanceBinding) : RecyclerView.ViewHolder(ui.root)
}