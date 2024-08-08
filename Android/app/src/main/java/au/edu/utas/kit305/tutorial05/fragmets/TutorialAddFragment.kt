package layout

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import au.edu.utas.kit305.tutorial05.*
import au.edu.utas.kit305.tutorial05.databinding.FragmentTutorialAddBinding

class TutorialAddFragment : BaseFragment() {
    lateinit var ui: FragmentTutorialAddBinding

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        ui = FragmentTutorialAddBinding.inflate(layoutInflater, container, false)
        ui.tuteSP.mySpinnerCallback {
            ui.txtSelectChecks.visibility = if (it == 1) View.VISIBLE else View.INVISIBLE
            ui.checksSP.visibility = if (it == 1) View.VISIBLE else View.INVISIBLE
            ui.txtSelectScore.visibility = if (it == 2) View.VISIBLE else View.INVISIBLE
            ui.scoreET.visibility = if (it == 2) View.VISIBLE else View.INVISIBLE
        }
        ui.nextBT.setOnClickListener {
            tutorialCollection.whereEqualTo("weekNo", ui.weekSP.selectedItemPosition + 1)
                .get()
                .addOnSuccessListener {
                    if (it.isEmpty) {
                        if (ui.tuteSP.selectedItemPosition == 2 && ui.scoreET.text.isEmpty()) {
                            showToast("Enter max score for the week")
                        } else if (ui.tuteSP.selectedItemPosition == 2 && ui.scoreET.text.toString().toInt() == 0) {
                            showToast("Max score should be greater than 0")
                        } else if (ui.tuteSP.selectedItemPosition == 2 && ui.scoreET.text.toString().toInt() > 100) {
                            showToast("Max score should be less than 100")
                        } else {
                            val bundle = Bundle()
                            bundle.putInt(B_WEEK_NO, ui.weekSP.selectedItemPosition)
                            bundle.putInt(B_TUTE_TYPE, ui.tuteSP.selectedItemPosition)
                            bundle.putInt(B_CHECKS_NO, ui.checksSP.selectedItemPosition + 1)
                            if (ui.tuteSP.selectedItemPosition == 2)
                                bundle.putInt(B_MAX_SCORE, ui.scoreET.text.toString().toInt())
                            val frag = TutorialMarkingFragment()
                            frag.arguments = bundle
                            act.supportFragmentManager
                                .beginTransaction()
                                .replace(R.id.frame_container, frag)
                                .addToBackStack(null)
                                .commit()
                        }
                    } else {
                        showToast("This week already exist")
                    }
                }

        }
        return ui.root
    }
}