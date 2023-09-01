package com.example.speedtrackerapp;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import android.Manifest;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import android.Manifest;
import android.content.pm.PackageManager;
import android.content.res.ColorStateList;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import android.content.Context;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity implements LocationListener {


    private LocationManager locationManager;


    private TextView mSpeedDisplay;

    private ProgressBar mSpeedTracker;

    private float mPreviousSpeed;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mSpeedDisplay = findViewById(R.id.SpeedDisplay);
        mSpeedTracker = findViewById(R.id.progressBar);

        mPreviousSpeed = 75;

        mSpeedTracker.setProgress( Math.round(mPreviousSpeed));

        locationManager = (LocationManager) getSystemService(LOCATION_SERVICE);

        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
                == PackageManager.PERMISSION_GRANTED &&
                ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION)
                        == PackageManager.PERMISSION_GRANTED) {

            locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 500, 0, this);


        } else {
            ActivityCompat.requestPermissions(this, new String[]{
                    Manifest.permission.ACCESS_FINE_LOCATION,
                    Manifest.permission.ACCESS_COARSE_LOCATION}, 1);
        }





    }

    // this function is called every second to update the speed




    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == 1) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
                        == PackageManager.PERMISSION_GRANTED &&
                        ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION)
                                == PackageManager.PERMISSION_GRANTED) {

                    locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 1000, 0, this);
                }
            } else {
                Toast.makeText(this, "Location permissions denied.", Toast.LENGTH_SHORT).show();
            }
        }
    }

    @Override
    public void onLocationChanged(Location location) {
        double latitude = location.getLatitude();
        double longitude = location.getLongitude();
        System.out.println(latitude + " - "+ longitude);

        double speed = location.getSpeed(); // Speed in meters per second
        double speedKmh = speed * 3.6; // Convert to kilometers per hour

        mSpeedDisplay.setText("Speed: " + speedKmh + " km/h");




        mPreviousSpeed += Math.random()*10;

        if(mPreviousSpeed < 0){
            mPreviousSpeed = 0;
        } else if (mPreviousSpeed > 200) {
            mPreviousSpeed = 0;
        }
        //mSpeedTracker.setProgressTintList( ColorStateList.valueOf(0xFF00FF00));

        mSpeedTracker.setProgress( Math.round(mPreviousSpeed));

    }



}