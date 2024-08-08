package au.edu.utas.kit305.tutorial05

import android.app.Activity
import android.app.AlertDialog
import android.content.Context
import android.content.Context.INPUT_METHOD_SERVICE
import android.content.Intent
import android.os.Bundle
import android.view.View
import android.view.inputmethod.InputMethodManager
import androidx.appcompat.app.AppCompatActivity
import au.edu.utas.kit305.tutorial05.databinding.ActivityMainBinding
import layout.HomeFragment
import layout.StudentAddFragment


class MainActivity : AppCompatActivity() {

    private lateinit var ui: ActivityMainBinding
    var backEnable = true

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        ui = ActivityMainBinding.inflate(layoutInflater)
        setContentView(ui.root)
        supportFragmentManager.beginTransaction().add(R.id.frame_container, HomeFragment()).commit()
    }

    fun hideSoftKeyboard() {
        try {
            val inputMethodManager = this
                .getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            inputMethodManager.hideSoftInputFromWindow(this.currentFocus!!.windowToken, 0)
        } catch (ignored: Exception) {
        }
    }

    override fun onBackPressed() {
        if(backEnable) {
            if (supportFragmentManager.backStackEntryCount > 0) {
                supportFragmentManager.popBackStack()
            } else {
                showExit()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if(requestCode== REQUEST_IMAGE_CAPTURE && resultCode== Activity.RESULT_OK){
            val frag = supportFragmentManager.findFragmentById(R.id.frame_container)
            if(frag is StudentAddFragment){
                frag.onPictureClicked()
            }
        }
    }

    private fun showExit() {
        val builder: AlertDialog.Builder = AlertDialog.Builder(this)
        builder.setMessage(getString(R.string.are_you_sure_want_to_exit))
            .setPositiveButton(getString(R.string.yes)
            ) { dialog, id -> finishAffinity() }
            .setNegativeButton(getString(R.string.no)
            ) { dialog, id -> dialog.cancel() }
        val alert: AlertDialog = builder.create()
        alert.show()
    }
}