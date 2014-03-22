// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ArticleDto.cs" company="">
//   
// </copyright>
// <summary>
//   Defines the ArticleDto type.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace NewsSightseeing.Web.Controllers
{
    using System;

    using MongoDB.Bson.Serialization.Attributes;

    public class ArticleDto
    {
        [BsonElement("_id")]
        public string Id { get; set; }

        [BsonElement("title")]
        public string Title { get; set; }

        [BsonElement("body")]
        public string Body { get; set; }

        [BsonElement("url")]
        public string Url { get; set; }

        [BsonElement("imageUrl")]
        public string ImageUrl { get; set; }

        [BsonElement("publishedAt")]
        public DateTime PublishedAt { get; set; }

        [BsonElement("location")]
        public double[] Location { get; set; }
    }
}