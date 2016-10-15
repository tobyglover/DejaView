package edu.tufts.cs.imghostapp;

import android.os.AsyncTask;
import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class MakePostRequest extends AsyncTask<Void, Void, JSONObject> {

    private static final String TAG = "MakeRequest";

    private String baseUrl = "http://dejaview.pictures/api/";
    private String pathUrl = "";
    private String[] getParams;
    private String myFilePath;

    public MakePostRequest(String pathUrl, String[] getParams, String filePath) {
        super();
        this.pathUrl = pathUrl;
        this.getParams = getParams;
        this.myFilePath = filePath;
    }

    @Override
    protected JSONObject doInBackground(Void... params) {

        String url = baseUrl + pathUrl + "?";
        for (int i = 0; i < getParams.length; i++) {
            url += getParams[i] + "&";
        }

        Log.v("**********", url);

        String charset = "UTF-8";

        try {
            MultipartUtility multipart = new MultipartUtility(url, charset);

            multipart.addHeaderField("User-Agent", "DejaViewAndroid");
            multipart.addFilePart("picture", new File(myFilePath));

            List<String> response = multipart.finish();

            System.out.println("SERVER REPLIED:");

            for (String line : response) {
                System.out.println(line);
            }
        } catch (IOException ex) {
            System.err.println(ex);
        }
        return null;
    }

}