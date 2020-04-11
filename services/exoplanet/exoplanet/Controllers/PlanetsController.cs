using System;
using System.Linq;
using System.Threading.Tasks;
using System.Collections.Generic;

using Microsoft.AspNetCore.Mvc;

using exoplanet.Authentication;
using exoplanet.Services;
using exoplanet.Models;

namespace exoplanet.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PlanetsController : ControllerBase
    {
        private const int MaxPlanetsCount = 10;

        private readonly ExoplanetService service;

        private readonly Authenticator authenticator;

        public PlanetsController(ExoplanetService service, Authenticator authenticator)
        {
            this.service = service;
            this.authenticator = authenticator;
        }

        [HttpGet("{id}", Name = nameof(GetPlanet))]
        public async Task<ActionResult<Planet>> GetPlanet(string id)
        {
            var planet = await service
                .GetPlanetAsync(id)
                .ConfigureAwait(false);

            if (planet == null)
                return NotFound();

            if (!planet.IsHidden)
                return Ok(planet);

            if (!Request.Cookies.TryGetValue("token", out var token))
                return Unauthorized();
            
            TokenInfo info;

            try
            {
                info = await this.authenticator
                    .ExtractTokenInfoAsync(token)
                    .ConfigureAwait(false);

                if (info.Content.Contains(Hasher.Hash(planet.Id)))
                    return Ok(planet);
            }
            catch
            {
                Response.Cookies.Delete("token");
            }
            
            return Unauthorized();
        }

        [HttpPost]
        public async Task<ActionResult> AddPlanet(Planet planet)
        {
            if (!Request.Cookies.TryGetValue("token", out var token))
                return Unauthorized();

            TokenInfo info;

            try
            {
                info = await this.authenticator
                    .ExtractTokenInfoAsync(token)
                    .ConfigureAwait(false);
            }
            catch 
            {
                Response.Cookies.Delete("token");
                return Unauthorized();
            }

            if (planet.StarId == null)
                return BadRequest();

            if (info.Owner != planet.StarId)
                return Unauthorized();

            var star = await service
                .GetStarAsync(planet.StarId)
                .ConfigureAwait(false);

            if (star == null)
                return NotFound();

            if (star.Planets.Count >= MaxPlanetsCount)
                return BadRequest();
            
            await service
                .AddPlanetAsync(planet, star)
                .ConfigureAwait(false);

            var newInfo = TokenInfo.Create(
                star.Id,
                star.Planets.Select(Hasher.Hash));

            var newToken = await this.authenticator
                .GenerateTokenAsync(newInfo)
                .ConfigureAwait(false);

            Response.Cookies.Append("token", newToken);

            return CreatedAtRoute(nameof(GetPlanet), new { id = planet.Id }, planet);
        }
    }
}
