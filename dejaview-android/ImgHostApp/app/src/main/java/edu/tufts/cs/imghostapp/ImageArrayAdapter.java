package edu.tufts.cs.imghostapp;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;

/**
 * Created by John on 10/14/16.
 */
public class ImageArrayAdapter extends ArrayAdapter<ImageElement> {
    private static final String TAG = "ImageArrayAdapter";

    private ArrayList<ImageElement> images = new ArrayList<>();
    private int layoutResourceId;
    private Context context;


    public ImageArrayAdapter(Context context, int layoutResourceId, ArrayList<ImageElement> images) {
        super(context, layoutResourceId, images);
        this.layoutResourceId = layoutResourceId;
        this.context = context;
        this.images = images;
    }

    public View getView(int position, View convertView, ViewGroup parent) {
        View row = convertView;
        ImageElement imageElement = images.get(position);
        ImageView imageView;

        if (row == null) {
            //Log.v(TAG, "ROW WAS NULL");
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();
            row = inflater.inflate(layoutResourceId, parent, false);
            imageView = (ImageView) row.findViewById(R.id.image);
            row.setTag(imageView);
        } else {
            //Log.v(TAG, "ROW WASN'T NULL");
            imageView = (ImageView) row.getTag();
        }
        if (imageElement != null) {
            imageView.setImageBitmap(imageElement.getImageScaled());
        }

        return row;
    }
}
