package edu.tufts.cs.imghostapp;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.location.LocationManager;
import android.net.Uri;
import android.os.Build;
import android.provider.MediaStore;
import android.support.design.widget.FloatingActionButton;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.GridView;
import android.widget.ImageView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;

public class ViewImages extends AppCompatActivity {

    private static final String TAG = "ViewImages";

    private static final int MY_WRITE_EXTERNAL_STORAGE_PERMISSION = 0;

    private GridView myGridView;
    private ImageArrayAdapter myImageArrayAdapter;
    private ArrayList<ImageElement> myImages;

    private FloatingActionButton myUploadImageButton;

    private int RESULT_LOAD_IMAGE = 1;

    private String myCode;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_view_images);

        myCode = getIntent().getStringExtra("code").toString();

        myImages = new ArrayList<>();


        myGridView = (GridView) findViewById(R.id.gridView);
        myImageArrayAdapter = new ImageArrayAdapter(this, R.layout.image_template, myImages);
        myGridView.setAdapter(myImageArrayAdapter);

        myUploadImageButton = (FloatingActionButton) findViewById(R.id.uploadImageButton);

        myUploadImageButton.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view) {
                attemptToBrowseImages();
            }
        });

        myGridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView parent, View v, int position, long id) {
                ByteArrayOutputStream stream = new ByteArrayOutputStream();
                Bitmap bmp = myImages.get(position).getImage();
                bmp.compress(Bitmap.CompressFormat.PNG, 100, stream);
                byte[] byteArray = stream.toByteArray();

                Intent intent = new Intent(v.getContext(), ImageDialog.class);
                intent.putExtra("image", byteArray);
                startActivity(intent);
            }
        });

        fetchImages();
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults) {
        switch (requestCode) {
            case MY_WRITE_EXTERNAL_STORAGE_PERMISSION: {
                // If request is cancelled, the result arrays are empty.
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    browseImages();

                } else {

                    // permission denied, boo! Disable the
                    // functionality that depends on this permission.
                }
                return;
            }

            // other 'case' lines to check for other
            // permissions this app might request
        }
    }

    private void fetchImages () {
        String [] getParams = new String[] {("eventId=" + myCode)};
        MakeRequest request = new MakeRequest("getImages", getParams){
            @Override
            protected void onPostExecute(JSONObject result) {
                if (result != null) {
                    Log.v(TAG, result.toString());
                    myImages.clear();
                    try {
                        JSONArray jsonImages = result.getJSONArray("images");
                        for (int i = 0; i < jsonImages.length(); i++) {
                            myImages.add(new ImageElement(new URL(jsonImages.getJSONObject(i).getString("url")), myImageArrayAdapter));
                        }
                    } catch (JSONException e) {

                    } catch (MalformedURLException e) {

                    }
                }
            }
        };
        request.execute();
        /*
        for (int i = 0; i < 20; i++) {
            try {
                ImageElement elem =
                        new ImageElement(new URL("http://www.dike.lib.ia.us/images/sample-1.jpg"), myImageArrayAdapter);
                myImages.add(elem);
                myImageArrayAdapter.notifyDataSetChanged();
            } catch (MalformedURLException e) {

            }
        }*/
    }


    private void attemptToBrowseImages () {
        if (ContextCompat.checkSelfPermission(this,
                Manifest.permission.WRITE_EXTERNAL_STORAGE)
                != PackageManager.PERMISSION_GRANTED) {

            // Should we show an explanation?
            if (ActivityCompat.shouldShowRequestPermissionRationale(this,
                    Manifest.permission.WRITE_EXTERNAL_STORAGE)) {

                Log.v(TAG, "SHOULD SHOW RATIONALE");


            } else {

                // No explanation needed, we can request the permission.
                Log.v(TAG, "SHOULD REQUEST PERMISSIONS");

                ActivityCompat.requestPermissions(this,
                        new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE},
                        MY_WRITE_EXTERNAL_STORAGE_PERMISSION);
            }
        }

        else {
            browseImages();
        }
    }

    private void browseImages() {
        Intent i = new Intent(
                Intent.ACTION_PICK,
                android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
        i.setType("image/*");
        startActivityForResult(i, RESULT_LOAD_IMAGE);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == RESULT_LOAD_IMAGE) {
            if (resultCode == RESULT_OK) {
                Uri selectedImage = data.getData();
                String[] filePathColumn = { MediaStore.Images.Media.DATA };

                Cursor cursor = getContentResolver().query(selectedImage,
                        filePathColumn, null, null, null);
                cursor.moveToFirst();

                int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
                String picturePath = cursor.getString(columnIndex);
                cursor.close();

                String [] getParams = new String[]{("eventId=" + myCode)};

                MakePostRequest request = new MakePostRequest("uploadImage", getParams, picturePath) {
                    @Override
                    public void onPostExecute(JSONObject result) {
                        Log.v(TAG, "POST REQUEST EXECUTED");
                        fetchImages();
                    }
                };
                request.execute();
            }
        }
    }
}
