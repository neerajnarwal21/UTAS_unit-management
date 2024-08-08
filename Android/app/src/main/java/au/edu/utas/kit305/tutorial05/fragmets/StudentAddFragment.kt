package layout

import android.Manifest
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import android.text.InputType.TYPE_NULL
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import androidx.core.content.ContextCompat
import androidx.core.content.FileProvider
import au.edu.utas.kit305.tutorial05.*
import au.edu.utas.kit305.tutorial05.data.Student
import au.edu.utas.kit305.tutorial05.databinding.FragmentStudentAddBinding
import com.bumptech.glide.Glide
import com.google.firebase.firestore.ktx.toObject
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.io.OutputStream
import java.text.SimpleDateFormat
import java.util.*

class StudentAddFragment : BaseFragment() {

    var photoFile: File? = null
    var compressPhotoFile: File? = null
    lateinit var ui: FragmentStudentAddBinding
    var student = Student()
    lateinit var currentPhotoPath: String
    var isUpdate = false

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        ui = FragmentStudentAddBinding.inflate(layoutInflater, container, false)

        ui.addStuIV.setOnClickListener {
            requestPermissions(
                arrayOf(Manifest.permission.CAMERA),
                REQUEST_IMAGE_CAPTURE
            )
        }

        val bundle = arguments
        var studentId: String? = ""
        if (bundle != null) {
            isUpdate = bundle.getBoolean(B_IS_UPDATE, false)
            studentId = bundle.getString(B_STUDENT_ID)
        }

        if (isUpdate) {
            val stu = students.find { student -> student.id.equals(studentId) }
            if (stu != null) {
                ui.stuIDET.setText(stu.id)
                ui.nameET.setText(stu.name)
                student.photoURL = stu.photoURL
                Glide.with(act).load(stu.photoURL)
                    .placeholder(ContextCompat.getDrawable(act, R.drawable.ic_user))
                    .circleCrop()
                    .into(ui.stuIV)
            } else {
                showToast("Something went wrong", true)
            }
            ui.stuIDET.disable()
            ui.txtTitle.text = "Update Student"
            ui.saveBT.text = "Update Student"
        }

        ui.saveBT.setOnClickListener {
            if (validate()) {
                if (isUpdate) {
                    updateDetails()
                } else {
                    studentsCollection.whereEqualTo("id", ui.stuIDET.text.toString())
                        .get()
                        .addOnSuccessListener {
                            if (it.isEmpty) {
                                updateDetails()
                            } else {
                                showToast("Student ID already exist", true)
                            }
                        }
                }
            }
        }
        return ui.root
    }

    private fun EditText.disable() {
        this.isFocusableInTouchMode = false
        this.setTextColor(ContextCompat.getColor(act, R.color.LightGrey))
        this.inputType = TYPE_NULL
    }

    private fun updateDetails() {
        student.id = ui.stuIDET.text.toString()
        student.name = ui.nameET.text.toString()
        act.backEnable = false
        if (compressPhotoFile != null) {
            val file = Uri.fromFile(compressPhotoFile)
            val ref =
                storage.reference.child("images/${student.id}/${file.lastPathSegment}")
            val uploadTask = ref.putFile(file)
            uploadTask.addOnSuccessListener {
                val downURL = ref.downloadUrl
                downURL.addOnSuccessListener {
                    student.photoURL = it.toString()
                    if (isUpdate) {
                        updateStudent()
                    } else {
                        addStudent()
                    }
                }
            }
            uploadTask.addOnFailureListener {
                it.message?.let { it1 -> Log.e(FIREBASE_TAG, it1) }
                showToast("Something went wrong", true)
                act.backEnable = true
            }
        } else {
            if (isUpdate) {
                updateStudent()
            } else {
                addStudent()
            }
        }
    }

    private fun updateStudent() {
        studentsCollection.whereEqualTo("id", student.id)
            .get()
            .addOnSuccessListener {
                val doc = it.documents[0]
                studentsCollection.document(doc.id).update(
                    mapOf(
                        "id" to student.id,
                        "name" to student.name,
                        "photoURL" to student.photoURL,
                        "active" to student.active
                    )
                )
                    .addOnSuccessListener {
                        //Reload student list once to update student collection list
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
                                    showToast("Student details updated successfully")
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

    fun addStudent() {
        studentsCollection.add(student)
            .addOnSuccessListener {
                act.backEnable = true
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
                            showToast("Student Added successfully", true)
                            act.supportFragmentManager.popBackStack()
                        }
                    }
            }
            .addOnFailureListener {
                Log.e(FIREBASE_TAG, "Error writing document", it)
                act.backEnable = true
            }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        when (requestCode) {
            REQUEST_IMAGE_CAPTURE -> {
                if ((grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED)) {
                    takeAPicture()
                } else {
                    showToast("Cannot access camera, permission denied", true)
                }
            }
        }
    }

    private fun takeAPicture() {
        val takePictureIntent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
        photoFile = createImageFile()
        if (photoFile != null) {
            val photoURI: Uri = FileProvider.getUriForFile(
                act,
                act.packageName,
                photoFile!!
            )
            takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, photoURI)
            act.startActivityForResult(takePictureIntent, REQUEST_IMAGE_CAPTURE)
        }
    }

    @Throws(IOException::class)
    private fun createImageFile(): File {
        val timeStamp: String = SimpleDateFormat("yyyyMMdd_HHmmss").format(Date())
        val storageDir: File = act.getExternalFilesDir(Environment.DIRECTORY_PICTURES)!!
        return File.createTempFile(
            "JPEG_${timeStamp}_", /* prefix */
            ".jpg", /* suffix */
            storageDir /* directory */
        ).apply {
            // Save a file: path for use with ACTION_VIEW intents
            currentPhotoPath = absolutePath
        }
    }

    private fun validate(): Boolean {
        if (ui.stuIDET.text.isEmpty()) {
            showToast("Please enter Student ID")
        } else if (ui.nameET.text.isEmpty()) {
            showToast("Please enter student name")
        } else {
            return true
        }
        return false
    }

    fun onPictureClicked() {
        val targetW: Int = ui.stuIV.measuredWidth
        val targetH: Int = ui.stuIV.measuredHeight

        val bmOptions = BitmapFactory.Options().apply {
            // Get the dimensions of the bitmap
            inJustDecodeBounds = true

            BitmapFactory.decodeFile(currentPhotoPath, this)

            val photoW: Int = outWidth
            val photoH: Int = outHeight

            // Determine how much to scale down the image
            val scaleFactor: Int = Math.max(1, Math.min(photoW / targetW, photoH / targetH))

            // Decode the image file into a Bitmap sized to fill the View
            inJustDecodeBounds = false
            inSampleSize = scaleFactor
        }
        val bm = BitmapFactory.decodeFile(currentPhotoPath, bmOptions)

        Log.d(FIREBASE_TAG, "Length: " + photoFile?.length())
        compressPhotoFile = bitmapToFile(bm)
        Log.d(FIREBASE_TAG, "Length Compress: " + compressPhotoFile?.length())

        Glide.with(this).load(compressPhotoFile).circleCrop().into(ui.stuIV)
    }

    //This method code is taken from the URL:
    // https://android--code.blogspot.com/2018/04/android-kotlin-convert-bitmap-to-file.html
    private fun bitmapToFile(bitmap: Bitmap): File {
        // Get the context wrapper
        val wrapper = ContextWrapper(act)

        // Initialize a new file instance to save bitmap object
        var file = wrapper.getDir("Images", Context.MODE_PRIVATE)
        file = File(file, "${UUID.randomUUID()}.jpg")

        try {
            // Compress the bitmap and save in jpg format
            val stream: OutputStream = FileOutputStream(file)
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, stream)
            stream.flush()
            stream.close()
        } catch (e: IOException) {
            e.printStackTrace()
        }

        // Return the saved bitmap uri
        return file
    }
}