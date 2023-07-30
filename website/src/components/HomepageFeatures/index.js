import React from 'react';
import clsx from 'clsx';
import styles from './styles.module.css';

const FeatureList = [
  {
    title: 'Effortless Animation',
    Svg: require('@site/static/img/undraw_docusaurus_mountain.svg').default,
    description: (
      <>
        Newton offers a user-friendly API and high configurability for easy creation of captivating visuals.
      </>
    ),
  },
  {
    title: 'Seamless Performance',
    Svg: require('@site/static/img/undraw_docusaurus_tree.svg').default,
    description: (
      <>
        Enjoy smooth particle animations, optimized for all devices, with Newton's performance-driven design.
      </>
    ),
  },
  {
    title: 'Limitless Creative Playground',
    Svg: require('@site/static/img/undraw_docusaurus_react.svg').default,
    description: (
      <>
         Unleash creativity using Newton's extensive configurability, crafting stunning particle effects with ease.
      </>
    ),
  },
];

function Feature({Svg, title, description}) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center padding-horiz--md">
        <h3>{title}</h3>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures() {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
