// --------------------------------------------------------------------------------------------------------------------
// <copyright file="DiscoverController.cs" company=""></copyright>
// <summary>
//   Defines the DiscoverController type.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace NewsSightseeing.Web.Controllers
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using System.Web.Http;

    using MongoDB.Bson;
    using MongoDB.Bson.Serialization;
    using MongoDB.Driver;

    public class DiscoverController : ApiController
    {
        private const double EarthRadius = 6378.0d; // km

        // GET api/values
        public IDictionary<string, IEnumerable<ArticleWebDto>> Get(double lat, double lng)
        {
            var connectionString = "mongodb://newssightseeing:XIj3lGlApxQsA4KdsDKbT4RAaB2Psk8Lvmfb0LbA.IQ-@ds031088.mongolab.com:31088/newssightseeing";
            var database = MongoDatabase.Create(connectionString);
            var articles = database.GetCollection<ArticleDto>("articles");

            var culture = CultureInfo.CreateSpecificCulture("en-US");
            var latString = lat.ToString(culture.NumberFormat);
            var lngString = lng.ToString(culture.NumberFormat);

            var hereWebDtos = this.GetHereArticles(articles, lngString, latString, culture);
            var veryCloseWebDtos = this.GetVeryCloseArticles(articles, lngString, latString, culture);
            var aroundYouWebDtos = this.GetAroundYouArticles(articles, lngString, latString, culture);
            var thisCityWebDtos = this.GetThisCityArticles(articles, lngString, latString, culture);

            return new Dictionary<string, IEnumerable<ArticleWebDto>>
                {
                    { "here", hereWebDtos },
                    { "veryClose", veryCloseWebDtos },
                    { "aroundYou", aroundYouWebDtos },
                    { "thisCity", thisCityWebDtos }
                };
        }

        private IEnumerable<ArticleWebDto> GetHereArticles(
            MongoCollection<ArticleDto> articles, 
            string lngString, 
            string latString, 
            CultureInfo culture)
        {
            var distance = 1.0d;
            var maxDistanceString = (distance / EarthRadius).ToString(culture.NumberFormat);

            var jsonQuery = "{ 'location' : { $geoWithin : { $centerSphere : [ [ " + lngString + " , " + latString + " ] , " + maxDistanceString + " ] } } }";

            var doc = BsonSerializer.Deserialize<BsonDocument>(jsonQuery);
            var query = new QueryDocument(doc);
            var results = articles.Find(query);

            var dtos = results.ToList().Select(ConvertArticleDtoToArticleWebDto());

            return dtos;
        }

        private IEnumerable<ArticleWebDto> GetVeryCloseArticles(
            MongoCollection<ArticleDto> articles,
            string lngString,
            string latString,
            CultureInfo culture)
        {
            var minDistance = 1.0d;
            var maxDistance = 3.0d;

            var minDistanceString = (minDistance / EarthRadius).ToString(culture.NumberFormat);
            var maxDistanceString = (minDistance / EarthRadius).ToString(culture.NumberFormat);

            var jsonQuery = "{ 'location' : { $geoWithin : { $centerSphere : [ [ " + lngString + " , " + latString + " ] , " + maxDistanceString + " ] } } }";

            var doc = BsonSerializer.Deserialize<BsonDocument>(jsonQuery);
            var query = new QueryDocument(doc);
            var results = articles.Find(query);

            var dtos = results.ToList().Select(ConvertArticleDtoToArticleWebDto());

            return dtos;
        }

        private IEnumerable<ArticleWebDto> GetAroundYouArticles(
            MongoCollection<ArticleDto> articles,
            string lngString,
            string latString,
            CultureInfo culture)
        {
            var minDistance = 1.0d;
            var maxDistance = 3.0d;

            var minDistanceString = (minDistance / EarthRadius).ToString(culture.NumberFormat);
            var maxDistanceString = (minDistance / EarthRadius).ToString(culture.NumberFormat);

            var jsonQuery = "{ 'location' : { $geoWithin : { $centerSphere : [ [ " + lngString + " , " + latString + " ] , " + maxDistanceString + " ] } } }";

            var doc = BsonSerializer.Deserialize<BsonDocument>(jsonQuery);
            var query = new QueryDocument(doc);
            var results = articles.Find(query);

            var dtos = results.ToList().Select(ConvertArticleDtoToArticleWebDto());

            return dtos;
        }

        private IEnumerable<ArticleWebDto> GetThisCityArticles(
            MongoCollection<ArticleDto> articles,
            string lngString,
            string latString,
            CultureInfo culture)
        {
            var minDistance = 1.0d;
            var maxDistance = 3.0d;

            var minDistanceString = (minDistance / EarthRadius).ToString(culture.NumberFormat);
            var maxDistanceString = (minDistance / EarthRadius).ToString(culture.NumberFormat);

            var jsonQuery = "{ 'location' : { $geoWithin : { $centerSphere : [ [ " + lngString + " , " + latString + " ] , " + maxDistanceString + " ] } } }";

            var doc = BsonSerializer.Deserialize<BsonDocument>(jsonQuery);
            var query = new QueryDocument(doc);
            var results = articles.Find(query);

            var dtos = results.ToList().Select(ConvertArticleDtoToArticleWebDto());

            return dtos;
        }

        private Func<ArticleDto, ArticleWebDto> ConvertArticleDtoToArticleWebDto()
        {
            return x => new ArticleWebDto()
                            {
                                Id = x.Id,
                                Title = x.Title,
                                Body = x.Body,
                                Url = x.Url,
                                ImageUrl = x.ImageUrl,
                                PublishedAt = x.PublishedAt,
                                Location = x.Location
                            };
        }
    }
}
