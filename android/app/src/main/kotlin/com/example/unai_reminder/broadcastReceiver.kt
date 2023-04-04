package com.example.unai_reminder

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.Settings

class BootReceiver : BroadcastReceiver() {

    private val REQUEST_OVERLAY_PERMISSIONS = 100

    override fun onReceive(context: Context?, intent: Intent?) {
        if (Intent.ACTION_BOOT_COMPLETED == intent?.action) {
            val launchIntent = context?.packageManager?.getLaunchIntentForPackage(context.packageName)
            launchIntent?.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            context?.startActivity(launchIntent)
            checkOverlayPermission(context)
        }
    }

    private fun checkOverlayPermission(context: Context?) {
        if (!Settings.canDrawOverlays(context)) {
            val myIntent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION)
            val uri: Uri = Uri.fromParts("package", context?.packageName, null)
            myIntent.data = uri
            myIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            context?.startActivity(myIntent)
        }
    }
}
