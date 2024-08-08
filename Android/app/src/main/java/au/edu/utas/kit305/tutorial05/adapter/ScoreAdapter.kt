package au.edu.utas.kit305.tutorial05.adapter

import android.content.Context
import android.util.Log
import android.view.LayoutInflater
import android.view.ViewGroup
import android.widget.Toast
import androidx.core.content.ContextCompat
import androidx.core.widget.addTextChangedListener
import androidx.recyclerview.widget.RecyclerView
import au.edu.utas.kit305.tutorial05.FIREBASE_TAG
import au.edu.utas.kit305.tutorial05.R
import au.edu.utas.kit305.tutorial05.Utils
import au.edu.utas.kit305.tutorial05.data.Tutorial
import au.edu.utas.kit305.tutorial05.databinding.ListItemScoreBinding
import com.bumptech.glide.Glide
import kotlin.math.roundToInt


class ScoreAdapter(
    private val tutorials: MutableList<Tutorial>,
    private val context: Context
) :
    RecyclerView.Adapter<ScoreAdapter.Holder>() {
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): Holder {
        val ui = ListItemScoreBinding.inflate(
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
        val tute = tutorials[position]
        holder.ui.nameTV.text = tute.studentName
        holder.ui.stuIDTV.text = tute.studentId
        Glide.with(context).load(tute.studentPic)
            .placeholder(ContextCompat.getDrawable(context, R.drawable.ic_user))
            .circleCrop()
            .into(holder.ui.picIV)
        holder.ui.maxScoreTV.text = "/${tute.maxScore}"
        holder.ui.scoreET.addTextChangedListener { text ->
            if (text != null && !text.isEmpty()) {
                if(text.toString().toInt()>tute.maxScore){
                    Toast.makeText(context, "Achieved score can not be great than max score", Toast.LENGTH_SHORT).show()
                    holder.ui.scoreET.setText("")
                }else {
                    tute.totalMarks = (text.toString().toFloat() / tute.maxScore * 100).roundToInt()
                    tute.score = text.toString().toInt()
                    Log.d(FIREBASE_TAG, tute.totalMarks.toString())
                    Utils.doUpdate()
                }
            }
        }
        holder.ui.scoreET.setText(tute.score.toString())
    }

    inner class Holder(var ui: ListItemScoreBinding) : RecyclerView.ViewHolder(ui.root)
}