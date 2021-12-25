package au.edu.utas.kit305.tutorial05

import android.view.View
import android.widget.AdapterView
import android.widget.Spinner

object Utils {
    private var updateListener: (() -> Unit)? = null
    fun setAverageListener(listener: (() -> Unit)) {
        this.updateListener = listener
    }

    fun doUpdate() {
        updateListener?.invoke()
    }
}
fun Spinner.mySpinnerCallback(callBack: (Int) -> Unit) {
    this.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
        override fun onNothingSelected(parent: AdapterView<*>?) {
        }

        override fun onItemSelected(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
            callBack.invoke(position)
        }
    }
}