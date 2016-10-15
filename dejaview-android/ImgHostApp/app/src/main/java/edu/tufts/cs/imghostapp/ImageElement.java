package edu.tufts.cs.imghostapp;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.Image;
import android.os.AsyncTask;
import android.util.Log;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;

/**
 * Created by John on 10/14/16.
 */
public class ImageElement {
    private static final String TAG = "ImageElement";

    private Bitmap myImageScaled;
    private URL myImageURL;
    private ImageArrayAdapter myImageArrayAdapter;

    public ImageElement (URL imageURL, ImageArrayAdapter i) {
        myImageArrayAdapter = i;
        myImageURL = imageURL;
        DownloadImage downloader = new DownloadImage() {
            @Override
            protected void onPostExecute(String result) {
                myImageArrayAdapter.notifyDataSetChanged();
            }
        };
        downloader.execute();
    }

    public Bitmap getImage() {
        return myImageScaled;
    }

    public Bitmap getImageScaled() {return myImageScaled;}

    public URL getMyImageURL() {
        return myImageURL;
    }

    private class DownloadImage extends AsyncTask<String, Void, String> {
        @Override
        protected String doInBackground(String... urls) {
            try {
                InputStream is = myImageURL.openConnection().getInputStream();
                Bitmap myImage = BitmapFactory.decodeStream(is);
                int desiredDimension = Math.min(400, Math.max(myImage.getWidth(), myImage.getHeight()));
                myImageScaled = Bitmap.createScaledBitmap(myImage, desiredDimension, desiredDimension, true);
                is.close();
            } catch (IOException e) {
                Log.v(TAG, "Couldn't read image from stream ... " + e.getMessage());
            }
            return null;
        }

    }
}
