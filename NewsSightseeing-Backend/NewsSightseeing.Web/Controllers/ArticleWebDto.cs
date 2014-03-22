// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ArticleWebDto.cs" company="">
//   
// </copyright>
// <summary>
//   Defines the ArticleWebDto type.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace NewsSightseeing.Web.Controllers
{
    using System;

    using Newtonsoft.Json;

    public class ArticleWebDto
    {
        [JsonProperty(PropertyName = "id")]
        public string Id { get; set; }

        [JsonProperty(PropertyName = "title")]
        public string Title { get; set; }

        [JsonProperty(PropertyName = "location")]
        public double[] Location { get; set; }

        [JsonProperty(PropertyName = "body")]
        public string Body { get; set; }

        [JsonProperty(PropertyName = "url")]
        public string Url { get; set; }

        [JsonProperty(PropertyName = "imageUrl")]
        public string ImageUrl { get; set; }

        [JsonProperty(PropertyName = "publishedAt")]
        public DateTime PublishedAt { get; set; }
    }
}