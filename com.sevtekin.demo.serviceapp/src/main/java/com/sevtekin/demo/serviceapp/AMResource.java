package com.sevtekin.demo.serviceapp;

import java.io.File;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.DateFormatSymbols;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;

import org.json.JSONArray;
import org.json.JSONObject;

import com.sevtekin.am.common.CashEntries;
import com.sevtekin.am.common.CashEntry;
import com.sevtekin.am.common.CategoryEntries;
import com.sevtekin.am.common.CategoryEntry;
import com.sevtekin.am.common.KeywordEntries;
import com.sevtekin.am.common.KeywordEntry;
import com.sevtekin.am.common.OwnerEntries;
import com.sevtekin.am.common.OwnerEntry;
import com.sevtekin.am.common.SnapshotEntries;
import com.sevtekin.am.common.SnapshotEntry;
import com.sevtekin.am.common.config.ConfigReader;
import com.sevtekin.am.common.config.EncryptionHandler;
import com.sevtekin.am.data.DataFacade;

@Path("/")
@Produces("application/xml")
public class AMResource {

	public AMResource() {
		
	}

	

	@GET
	@Path("products")
	@Produces("application/json")
	public Response getProducts() {
		JSONObject result = new JSONObject();
		JSONArray objects = new JSONArray();
		JSONObject object = new JSONObject();
		object = new JSONObject();
		object.put("name", "value");
		objects.put(object);
		result.put("products", objects);
		return Response.ok(result.toString(), MediaType.APPLICATION_JSON).build();
	}
}
