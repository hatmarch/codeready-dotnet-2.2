using System;
using Microsoft.AspNetCore.Mvc;
using System.Net;
using System.Net.Http;

namespace dotnet.Controllers
{
	[Route("/")]
	public class ValuesController : Controller
	{
		// Bryon is awesome
		const string url = "http://preference.coles-demo.svc.cluster.local:8080";
		const string responseStringFormat = "customer {0} => {1}\n";

		static HttpClient client = new HttpClient();

		private string callPreference()
		{
			string response = "unknown";
			try
			{
				using (var task = client.GetStringAsync(url))
				{
					response = task.Result;
				}
			}
			catch (Exception e)
			{
				Console.WriteLine("Error calling preference service: {0}", e.Message);
			}

			return response;
		}

		// GET api/values
		[HttpGet]
		public string Get()
		{
			string hostname = Dns.GetHostName();
			return String.Format(responseStringFormat, hostname, callPreference());
		}
	}
}
