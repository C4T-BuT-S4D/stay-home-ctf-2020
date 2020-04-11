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
            var planet = await service.GetPlanetAsync(id)
                .ConfigureAwait(false);

            if (planet == null)
                return NotFound();

            var star = await service.GetStarAsync(planet.StarId)
                .ConfigureAwait(false);

            if (star == null)
                return NotFound();

            if (!planet.IsHidden)
                return Ok(planet);

            if (!Request.Cookies.TryGetValue("token", out var token))
                return Unauthorized();
            
            IEnumerable<string> content;

            try
            {
                content = await this.authenticator.ExtractTokenContentAsync(
                    token, 
                    star.Id, 
                    star.Name
                ).ConfigureAwait(false);
            }
            catch
            {
                Response.Cookies.Delete("token");
                return Unauthorized();
            }

            if (content.Contains(Hasher.Hash(planet.Id)))
                return Ok(planet);
            
            return Unauthorized();
        }

        [HttpPost]
        public async Task<ActionResult> AddPlanet(Planet planet)
        {
            if (planet.StarId == null)
                return NotFound();

            var star = await service.GetStarAsync(planet.StarId)
                .ConfigureAwait(false);

            if (star == null)
                return NotFound();

            if (star.Planets.Count >= MaxPlanetsCount)
                return BadRequest();

            if (!Request.Cookies.TryGetValue("token", out var token))
                return Unauthorized();

            IEnumerable<string> content;

            try
            {
                content = await this.authenticator.ExtractTokenContentAsync(
                    token,
                    star.Id,
                    star.Name
                ).ConfigureAwait(false);
            }
            catch 
            {
                Response.Cookies.Delete("token");
                return Unauthorized();
            }
            
            await service.AddPlanetAsync(planet, star)
                .ConfigureAwait(false);

            var newToken = await this.authenticator.GenerateTokenAsync(
                star.Id,
                star.Name,
                content.Append(Hasher.Hash(planet.Id))
            ).ConfigureAwait(false);

            Response.Cookies.Append("token", newToken);

            return CreatedAtRoute(nameof(GetPlanet), new { id = planet.Id }, planet);
        }
    }
}
