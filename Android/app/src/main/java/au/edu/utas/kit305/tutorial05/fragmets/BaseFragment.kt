package layout

import android.os.Bundle
import android.widget.Toast
import androidx.fragment.app.Fragment
import au.edu.utas.kit305.tutorial05.MainActivity

open class BaseFragment : Fragment() {
    lateinit var act: MainActivity

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        act = activity as MainActivity
        act.hideSoftKeyboard()
    }

    fun showToast(msg: String, isLong: Boolean = false) {
        Toast.makeText(act, msg, if (isLong) Toast.LENGTH_LONG else Toast.LENGTH_SHORT).show()
    }
}