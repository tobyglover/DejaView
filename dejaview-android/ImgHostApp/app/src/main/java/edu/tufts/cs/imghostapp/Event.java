package edu.tufts.cs.imghostapp;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.util.Log;

import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;

/**
 * Created by John on 10/14/16.
 */
public class Event {
    private static final String TAG = "Event";

    private String myTitle;
    private String myCode;
    private URL myImageURL;
    private Bitmap myImage;

    public Event(String code, String title, URL imageURL) {
        myCode = code;
        myTitle = title;
        myImageURL = imageURL;

        if (myImageURL != null) {
            DownloadImage downloader = new DownloadImage() {
                @Override
                protected void onPostExecute(Bitmap result) {
                    myImage = result;
                }
            };
            downloader.execute();
        }
    }

    public Bitmap getImage() {
        return myImage;}
    public String getCode() {
        return myCode;
    }
    public String getTitle() {return myTitle;}
    public URL getMyImageURL() {
        return myImageURL;
    }

    private class DownloadImage extends AsyncTask<String, Void, Bitmap> {
        @Override
        protected Bitmap doInBackground(String... urls) {
            Bitmap newImage = null;
            try {
                InputStream is = myImageURL.openConnection().getInputStream();
                Bitmap image = BitmapFactory.decodeStream(is);
                int desiredDimension = Math.min(200, Math.max(image.getWidth(), image.getHeight()));
                newImage = Bitmap.createScaledBitmap(image, desiredDimension, desiredDimension, true);
                is.close();
            } catch (IOException e) {
                Log.v(TAG, "Couldn't read image from stream ... " + e.getMessage());
            }
            return newImage;
        }

    }
}
