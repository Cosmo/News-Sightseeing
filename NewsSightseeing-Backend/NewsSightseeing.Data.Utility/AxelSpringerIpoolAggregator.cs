namespace NewsSightseeing.Data.Utility
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Globalization;
    using System.Linq;
    using System.Net.Http;
    using System.Net.Mime;
    using System.Security.Policy;

    using MongoDB.Driver;

    using NewsSightseeing.Data.Dto;

    using Newtonsoft.Json;

    internal class AxelSpringerIpoolAggregator
    {
        private const string RequestUrl = "http://ipool-extern.s.asideas.de:9090/api/v2/search?geos=%22Berlin%22&offset=";

        public void Aggregate()
        {
            var client = new HttpClient();
            var offset = 0;
            var totalCount = 0;
            var pageSize = 10;

            var items = new List<Document>();
            var candidates = new List<Document>();

            do
            {
                string url = RequestUrl + offset;
                string json = client.GetStringAsync(url).Result;

                var result = JsonConvert.DeserializeObject<SearchResponse>(json);
                if (result != null && result.Documents != null)
                {
                    offset += pageSize;
                    totalCount = result.Pagination.Total;

                    var documents = result.Documents.Where(x =>
                        x.Medias != null && 
                        x.Medias.Any(m => m.References.Any(r => r.Height >= 600 && r.Width >= 600)) &&
                        x.Linguistics != null && 
                        x.Linguistics.Geos != null && 
                        x.Linguistics.Geos.Any());

                    if (documents != null && documents.Any())
                    {
                        foreach (var document in documents)
                        {
                            var topGeos = document.Linguistics.Geos.OrderByDescending(x => x.Weight).Take(2).ToList();

                            if (!string.IsNullOrWhiteSpace(document.Linguistics.Location))
                            {
                                // Skip Berlin centering news...
                                if (topGeos.Count == 2 && 
                                    ((topGeos[0].Lemma == "Deutschland" && topGeos[1].Lemma == "Berlin")
                                    || (topGeos[0].Lemma == "Berlin" && topGeos[1].Lemma == "Deutschland")))
                                {
                                    continue;
                                }

                                items.Add(document);
                                continue;
                            }

                            //if (topGeos.Count() == 2 && topGeos.Any(x => x.Lemma == "Berlin"))
                            //{
                            //    var first = topGeos[0];
                            //    var second = topGeos[1];
                            //    document.GeoQueryParameter = string.Format("{0} {1}", first.Lemma, second.Lemma).Replace(" ", "+");
                            //    candidates.Add(document);
                            //    continue;
                            //}
                        }
                    }
                }
                else
                {
                    break;
                }
            }
            while (items.Count < 1000 && offset <= totalCount);

            var connectionString = "mongodb://newssightseeing:XIj3lGlApxQsA4KdsDKbT4RAaB2Psk8Lvmfb0LbA.IQ-@ds031088.mongolab.com:31088/newssightseeing";
            var database = MongoDatabase.Create(connectionString);
            var articles = database.GetCollection<ArticleDto>("articles");

            foreach (var document in items)
            {
                Reference imageReference = null;
                foreach (var media in document.Medias)
                {
                    if (media.Type != "PICTURE") continue;
                    foreach (var reference in media.References)
                    {
                        if (reference.Height >= 600 && reference.Height >= 600)
                        {
                            imageReference = reference;
                            break;
                        }
                    }
                }

                if (imageReference == null) continue;

                var culture = CultureInfo.CreateSpecificCulture("en-US");
                var latLongStrings = document.Linguistics.Location.Split(",".ToCharArray());
                double[] location =
                    {
                        double.Parse(latLongStrings[1], culture.NumberFormat), 
                        double.Parse(latLongStrings[0], culture.NumberFormat)
                    };

                var unixYear0 = new DateTime(1970, 1, 1);
                var unixTimeStampInTicks = document.DateCreated * 10000;
                var publishedAt = new DateTime(unixYear0.Ticks + unixTimeStampInTicks);

                var article = new ArticleDto();
                article.Id = "axelspringer_" + document.Id;
                article.ImageUrl = imageReference.Url;
                article.Location = location;
                article.PublishedAt = publishedAt;
                article.Title = document.Title;
                article.Body = document.Content;
                article.Url = document.PublishedUrl;

                articles.Save(article);
            }
        }
    }

    public class SearchResponse
    {
        [JsonProperty("documents")]
        public Document[] Documents { get; set; }

        [JsonProperty("pagination")]
        public Pagination Pagination { get; set; }
    }

    public class Pagination
    {
        [JsonProperty("total")]
        public int Total { get; set; }

        [JsonProperty("offset")]
        public int Offset { get; set; }
    }

    public class Document
    {
        [JsonProperty("id")]
        public string Id { get; set; }

        [JsonProperty("dateCreated")]
        public long DateCreated { get; set; }

        [JsonProperty("publishedURL")]
        public string PublishedUrl { get; set; }

        [JsonProperty("title")]
        public string Title { get; set; }

        [JsonProperty("content")]
        public string Content { get; set; }

        [JsonProperty("linguistics")]
        public Linguistics Linguistics { get; set; }

        [JsonProperty("medias")]
        public Media[] Medias { get; set; }

        public string GeoQueryParameter { get; set; }
    }

    public class Media
    {
        [JsonProperty("type")]
        public string Type { get; set; }

        [JsonProperty("references")]
        public Reference[] References { get; set; }
    }

    public class Reference
    {
        [JsonProperty("url")]
        public string Url { get; set; }

        [JsonProperty("width")]
        public int Width { get; set; }

        [JsonProperty("height")]
        public int Height { get; set; }
    }

    public class Linguistics
    {
        [JsonProperty("location")]
        public string Location { get; set; }

        [JsonProperty("geos")]
        public Geo[] Geos { get; set; }
    }

    public class Geo
    {
        [JsonProperty("lemma")]
        public string Lemma { get; set; }

        [JsonProperty("weight")]
        public float Weight { get; set; }
    }
}