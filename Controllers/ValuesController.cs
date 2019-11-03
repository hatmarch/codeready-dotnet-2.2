using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using System.Net;
using System.Net.Http;

namespace dotnet.Controllers
{
    [Route("/")]
    public class ValuesController : Controller
    {
        const string url = "http://preference.coles-demo.svc.cluster.local:8080";
        const string responseStringFormat = "Hello from {0}> customer => {1}\n";

        static readonly HttpClient client = new HttpClient();



        private string callPreference()
		{
			//           HttpResponseMessage response = await client.GetAsync(url);
			//           response.EnsureSuccessStatusCode();
			//           string responseBody = await response.Content.ReadAsStringAsync();
            string responseBody = "unknown";
			using (var task = client.GetStringAsync(url))
			{
                try
                {
				    responseBody = task.Result;
                }
                catch( Exception e )
                {
                    responseBody = e.Message;
                }
			}

			return responseBody;
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
